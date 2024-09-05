# SQLite.Core.NetStandard
SQLite database engine for multiple architectures along with the ADO.NET provider

This project creates a [NuGet package](https://github.com/rhubarb-geek-nz/SQLite.Core.NetStandard/pkgs/nuget/rhubarb-geek-nz.SQLite.Core.NetStandard) containing multiple native implementations.

The Windows binaries come from [rhubarb-geek-nz/SQLite.Interop-win](https://github.com/rhubarb-geek-nz/SQLite.Interop-win/releases)

The OSX and Linux binaries come from [rhubarb-geek-nz/SQLite.Interop](https://github.com/rhubarb-geek-nz/SQLite.Interop/releases)

The provider comes from [Precompiled Binaries for the .NET Standard 2.0](https://system.data.sqlite.org/index.html/doc/trunk/www/downloads.wiki)

The [test project](test.csproj) references this package and is exercised using [test.ps1](test.ps1).

The test project demonstrates the usage of multiple architectures.

```
System.Data.SQLite.dll
ref/test.dll
runtimes/freebsd-arm64/native/SQLite.Interop.dll
runtimes/freebsd-x64/native/SQLite.Interop.dll
runtimes/linux-arm/native/SQLite.Interop.dll
runtimes/linux-arm64/native/SQLite.Interop.dll
runtimes/linux-bionic-arm/native/SQLite.Interop.dll
runtimes/linux-bionic-arm64/native/SQLite.Interop.dll
runtimes/linux-bionic-x64/native/SQLite.Interop.dll
runtimes/linux-musl-arm/native/SQLite.Interop.dll
runtimes/linux-musl-arm64/native/SQLite.Interop.dll
runtimes/linux-musl-x64/native/SQLite.Interop.dll
runtimes/linux-x64/native/SQLite.Interop.dll
runtimes/osx-arm64/native/SQLite.Interop.dll
runtimes/osx-x64/native/SQLite.Interop.dll
runtimes/win-arm/native/SQLite.Interop.dll
runtimes/win-arm64/native/SQLite.Interop.dll
runtimes/win-x64/native/SQLite.Interop.dll
runtimes/win-x86/native/SQLite.Interop.dll
test
test.deps.json
test.dll
test.pdb
test.runtimeconfig.json
```

The [GPL3 license](LICENSE) refers to this packaging project itself.

[SQLite is Public Domain](https://www.sqlite.org/copyright.html)
