//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_secure_storage_linux/flutter_secure_storage_linux_plugin.h>
#include <siwe_flutter/siwe_flutter_plugin.h>
#include <sodium_libs/sodium_libs_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_secure_storage_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterSecureStorageLinuxPlugin");
  flutter_secure_storage_linux_plugin_register_with_registrar(flutter_secure_storage_linux_registrar);
  g_autoptr(FlPluginRegistrar) siwe_flutter_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SiweFlutterPlugin");
  siwe_flutter_plugin_register_with_registrar(siwe_flutter_registrar);
  g_autoptr(FlPluginRegistrar) sodium_libs_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SodiumLibsPlugin");
  sodium_libs_plugin_register_with_registrar(sodium_libs_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
