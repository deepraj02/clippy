locale:
	arb_translate && fvm dart  run intl_utils:generate

gen:
	fvm dart  run build_runner build --delete-conflicting-outputs

watch:
	fvm dart  run build_runner watch --delete-conflicting-outputs 