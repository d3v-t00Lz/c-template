%define release 1

Summary: TODO
Name: %{name}
Version: %{version}
Release: %{release}
Source0: %{name}-%{version}.tar.gz
License: TODO
Group: Development/Libraries
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Prefix: %{_prefix}
Vendor: TODO <TODO@TODO.org>
Url: https://gitlab.com/jaelen/c-template

%description
TODO

%prep
cd %{_builddir}/%{name}-%{version}

%build
cd %{_builddir}/%{name}-%{version}
make

%install
cd %{_builddir}/%{name}-%{version}
DESTDIR=$RPM_BUILD_ROOT make install

%clean
cd %{_builddir}/%{name}-%{version}
make clean

%files
%defattr(-,root,root)
%attr(755, root, root) %{_usr}/bin/%{name}
