package com.erluxman.pdf_flutter;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * PdfFlutterPlugin
 */
public class PdfFlutterPlugin implements FlutterPlugin {

    /**
     * Legacy method for supporting apps that have not migrated to the v2 Android embedding
     */
    @SuppressWarnings("deprecation")
    public static void registerWith(Registrar registrar) {
        registrar
                .platformViewRegistry()
                .registerViewFactory(
                        "pdf_flutter_plugin", new PdfFlutterFactory(registrar.messenger()));
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        binding
                .getPlatformViewRegistry()
                .registerViewFactory(
                        "pdf_flutter_plugin", new PdfFlutterFactory(binding.getBinaryMessenger()));
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }


}
