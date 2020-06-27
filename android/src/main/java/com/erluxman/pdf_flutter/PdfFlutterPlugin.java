package com.erluxman.pdf_flutter;

import io.flutter.plugin.common.PluginRegistry.Registrar;

/** PdfFlutterPlugin */
public class PdfFlutterPlugin {
  public static void registerWith(Registrar registrar) {
    registrar
            .platformViewRegistry()
            .registerViewFactory(
                    "pdf_flutter_plugin", new PdfFlutterFactory(registrar.messenger()));
  }
}
