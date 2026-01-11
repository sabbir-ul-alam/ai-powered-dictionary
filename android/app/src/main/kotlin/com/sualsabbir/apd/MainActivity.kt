package com.sualsabbir.apd

import io.flutter.embedding.android.FlutterActivity

import android.content.ContentUris
import android.content.ContentValues
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.database.Cursor
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.FileInputStream

class MainActivity: FlutterActivity() {

    private val CHANNEL = "apd.backup.channel"
    private val DB_NAME = "dictionary.db"

    // Public folder inside Documents
    private val RELATIVE_DIR = "Documents/APD/Backups/"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "exportBackup" -> {
                        val dbFilePath = call.argument<String>("dbFilePath")
                        exportBackupToDocuments(dbFilePath)
                        result.success(null)
                    }
                    "listBackups" -> {
                        val list = listBackupsFromDocuments()
                        result.success(list)
                    }
                    "restoreBackup" -> {
                        val uriStr = call.argument<String>("uri") ?: ""
                        if (uriStr.isBlank()) throw IllegalArgumentException("Missing backup uri")
                        restoreBackupFromUri(Uri.parse(uriStr))
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("BACKUP_ERROR", e.message, null)
            }
        }
    }

    /**
     * Exports the app.db file into MediaStore at Documents/APD/Backups.
     * Works properly on Android 10+ (API 29+). For older devices, you can add a fallback later.
     */
    private fun exportBackupToDocuments(dbFilePath: String?) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            // Minimal fallback for old Android. You can improve later.
            throw IllegalStateException("Android version too old for MediaStore Documents backup without permissions.")
        }

        val dbFile = getDatabasePath(DB_NAME)
        if (!dbFile.exists()) {
            throw IllegalStateException("DDatabase file does not exist at: ${dbFile.absolutePath}")
        }

        val timestamp = System.currentTimeMillis()
        val fileName = "apd_backup_$timestamp.db"

        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
            put(MediaStore.MediaColumns.MIME_TYPE, "application/octet-stream")
            put(MediaStore.MediaColumns.RELATIVE_PATH, RELATIVE_DIR)
            put(MediaStore.MediaColumns.IS_PENDING, 1)
        }

        val collection: Uri = MediaStore.Files.getContentUri("external")
        val itemUri = contentResolver.insert(collection, values)
            ?: throw IllegalStateException("Failed to create backup entry in MediaStore")

        contentResolver.openOutputStream(itemUri)?.use { out ->
            FileInputStream(dbFile).use { input ->
                input.copyTo(out)
            }
        } ?: throw IllegalStateException("Failed to open output stream for backup")

        // Mark done
        values.clear()
        values.put(MediaStore.MediaColumns.IS_PENDING, 0)
        contentResolver.update(itemUri, values, null, null)
    }

    private fun listBackupsFromDocuments(): List<Map<String, Any>> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            throw IllegalStateException("Android version too old for MediaStore Documents listing without permissions.")
        }

        val collection: Uri = MediaStore.Files.getContentUri("external")

        val projection = arrayOf(
            MediaStore.MediaColumns._ID,
            MediaStore.MediaColumns.DISPLAY_NAME,
            MediaStore.MediaColumns.DATE_MODIFIED,
            MediaStore.MediaColumns.SIZE,
            MediaStore.MediaColumns.RELATIVE_PATH
        )

        val selection = "${MediaStore.MediaColumns.RELATIVE_PATH} LIKE ? AND ${MediaStore.MediaColumns.DISPLAY_NAME} LIKE ?"
        val selectionArgs = arrayOf("%APD/Backups%", "apd_backup_%.db")

        val list = mutableListOf<Map<String, Any>>()

        val cursor: Cursor? = contentResolver.query(
            collection,
            projection,
            selection,
            selectionArgs,
            "${MediaStore.MediaColumns.DATE_MODIFIED} DESC"
        )

        cursor?.use {
            val idCol = it.getColumnIndexOrThrow(MediaStore.MediaColumns._ID)
            val nameCol = it.getColumnIndexOrThrow(MediaStore.MediaColumns.DISPLAY_NAME)
            val modifiedCol = it.getColumnIndexOrThrow(MediaStore.MediaColumns.DATE_MODIFIED)
            val sizeCol = it.getColumnIndexOrThrow(MediaStore.MediaColumns.SIZE)

            while (it.moveToNext()) {
                val id = it.getLong(idCol)
                val name = it.getString(nameCol) ?: "backup.db"
                val modifiedSeconds = it.getLong(modifiedCol) // seconds
                val sizeBytes = it.getLong(sizeCol)

                val uri = ContentUris.withAppendedId(collection, id)

                list.add(
                    mapOf(
                        "name" to name,
                        "uri" to uri.toString(),
                        "modifiedAtMs" to (modifiedSeconds * 1000L).toInt(),
                        "sizeBytes" to sizeBytes.toInt()
                    )
                )
            }
        }

        return list
    }

    /**
     * Restores backup content:// Uri into app.db.
     * After this, the Flutter app must restart (exit & relaunch) to reload Drift safely.
     */
    private fun restoreBackupFromUri(uri: Uri) {
        val dbFile = getDatabasePath(DB_NAME)

        // Overwrite app.db
        contentResolver.openInputStream(uri)?.use { input ->
            dbFile.outputStream().use { output ->
                input.copyTo(output)
            }
        } ?: throw IllegalStateException("Failed to open input stream for restore")
    }
}
