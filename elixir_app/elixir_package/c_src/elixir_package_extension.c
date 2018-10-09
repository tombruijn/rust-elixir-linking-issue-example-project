#ifdef __GNUC__
#define UNUSED(x) UNUSED_ ## x __attribute__((__unused__))
#else
#define UNUSED(x) UNUSED_ ## x
#endif

#include "erl_nif.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <elixir_package_extension.h>

static ERL_NIF_TERM _start(ErlNifEnv* env, int UNUSED(arc), const ERL_NIF_TERM UNUSED(argv[])) {
  return enif_make_int64(env, elixir_package_extension_start());
}

static ERL_NIF_TERM _stop(ErlNifEnv* env, int UNUSED(arc), const ERL_NIF_TERM UNUSED(argv[])) {
  return enif_make_int64(env, elixir_package_extension_stop());
}

static ERL_NIF_TERM _loaded(ErlNifEnv *env, int UNUSED(argc), const ERL_NIF_TERM UNUSED(argv[])) {
  return enif_make_atom(env, "true");
}

static int on_load(ErlNifEnv* UNUSED(env), void** UNUSED(priv), ERL_NIF_TERM UNUSED(info)) {
  return 0;
}

static int on_reload(ErlNifEnv* UNUSED(env), void** UNUSED(priv_data), ERL_NIF_TERM UNUSED(load_info)) {
  return 0;
}

static int on_upgrade(ErlNifEnv* UNUSED(env), void** UNUSED(priv), void** UNUSED(old_priv_data), ERL_NIF_TERM UNUSED(load_info)) {
  return 0;
}

static ErlNifFunc nif_funcs[] =
{
  {"_start", 0, _start, 0},
  {"_stop", 0, _stop, 0},
  {"_loaded", 0, _loaded, 0}
};

ERL_NIF_INIT(Elixir.ElixirPackage.Nif, nif_funcs, on_load, on_reload, on_upgrade, NULL)
