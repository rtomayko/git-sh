%global _enable_debug_package 0
%global debug_package %{nil}
%global __os_install_post /usr/lib/rpm/brp-compress %{nil}

Name:           git-sh
Version:        1.3
Release:        1%{?dist}
Summary:        A customized bash shell suitable for git work

License:        GPLv2
URL:            https://github.com/rtomayko/%{name}
Source0:        https://github.com/rtomayko/%{name}/archive/%{version}.tar.gz

%description
A customized bash shell suitable for git work.

%prep
%setup

%build
make

%install
rm -rf $RPM_BUILD_ROOT
%make_install PREFIX=$RPM_BUILD_ROOT/usr/

%files
%doc CHANGES COPYING README.markdown
%{_bindir}/*
%{_mandir}/*

%changelog
* Thu Feb  6 2014 Leonid Podolny <leonid@podolny.net> - 1.3-1
- Initial spec file
