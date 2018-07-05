# ---------- Archive support ----------
.PHONY: help_archive # Generate list of Archive targets with descriptions.
help_archive:
	@echo Use one of the following Archive targets:
ifeq ($(SYSTEM),win)
	@$(GREP) "^.PHONY: .* #" $(CURDIR)/makefiles/Makefile.archive.mk | $(SED) "s/\.PHONY: \(.*\) # \(.*\)/\1\t\2/"
	@echo off & echo(
else
	@$(GREP) "^.PHONY: .* #" $(CURDIR)/makefiles/Makefile.archive.mk | $(SED) "s/\.PHONY: \(.*\) # \(.*\)/\1\t\2/" | expand -t20
	@echo
endif

temp_archive:
	-$(DELREC) temp_archive
	$(MKDIR_P) temp_archive$S$(INSTALL_DIR)

# Main target
.PHONY: archive # Create OR-Tools archive for C++, Java and .Net with Examples.
archive: archive_cc archive_dotnet archive_java
	$(COPY) tools$SREADME.cc.java.dotnet temp_archive$S$(INSTALL_DIR)$SREADME
	$(COPY) tools$SMakefile.cc.java.dotnet temp_archive$S$(INSTALL_DIR)$SMakefile

.PHONY: clean_archive # Clean Archive output from previous build.
clean_archive:
	-$(DELREC) temp_archive

.PHONY: archive_cc # Add C++ OR-Tools to archive.
archive_cc: cc | temp_archive
	$(MAKE) install_cc prefix=temp_archive$S$(INSTALL_DIR)
	$(COPY) $(CVRPTW_PATH) temp_archive$S$(INSTALL_DIR)$Slib
	$(COPY) $(DIMACS_PATH) temp_archive$S$(INSTALL_DIR)$Slib
	$(COPY) $(FAP_PATH) temp_archive$S$(INSTALL_DIR)$Slib
	$(MKDIR_P) temp_archive$S$(INSTALL_DIR)$Sexamples$Scpp
	$(COPY) examples$Scpp$S*.cc temp_archive$S$(INSTALL_DIR)$Sexamples$Scpp
	$(COPY) examples$Scpp$S*.h  temp_archive$S$(INSTALL_DIR)$Sexamples$Scpp

.PHONY: archive_dotnet # Add .Net OR-Tools to archive.
archive_dotnet: dotnet | temp_archive
	"$(DOTNET_EXECUTABLE)" publish \
 -f netstandard2.0 \
 -c Release \
 -o "..$S..$S..$Stemp_archive$S$(INSTALL_DIR)" \
 ortools$Sdotnet$S$(ORTOOLS_DLL_NAME)$S$(ORTOOLS_DLL_NAME).csproj
	"$(DOTNET_EXECUTABLE)" publish \
 -f netstandard2.0 \
 -c Release \
 -o "..$S..$S..$Stemp_archive$S$(INSTALL_DIR)" \
 ortools$Sdotnet$S$(ORTOOLS_FSHARP_DLL_NAME)$S$(ORTOOLS_FSHARP_DLL_NAME).fsproj
	$(COPY) $(BIN_DIR)$S$(CLR_ORTOOLS_IMPORT_DLL_NAME).$(SWIG_DOTNET_LIB_SUFFIX) temp_archive$S$(INSTALL_DIR)

.PHONY: archive_java # Add Java OR-Tools to archive.
archive_java: java | temp_archive


#archive: $(INSTALL_DIR)$(ARCHIVE_EXT)

$(INSTALL_DIR)$(ARCHIVE_EXT): cc_archive dotnet_archive java_archive
ifeq ($(SYSTEM),win)
	cd temp && ..$Stools$Szip.exe -r ..$S$(INSTALL_DIR).zip $(INSTALL_DIR)
else
	cd temp && tar -c -v -z --no-same-owner -f ..$S$(INSTALL_DIR).tar.gz $(INSTALL_DIR)
endif
	-$(DELREC) temp

.PHONY: create_dirs
create_dirs:
	-$(DELREC) temp
	$(MKDIR) temp
	$(MKDIR) temp$S$(INSTALL_DIR)
	$(MKDIR) temp$S$(INSTALL_DIR)$Slib
	$(MKDIR) temp$S$(INSTALL_DIR)$Sobjs
	$(MKDIR) temp$S$(INSTALL_DIR)$Sbin
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Salgorithms
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sbase
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sconstraint_solver
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sdata
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sgflags
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sglog
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sbop
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sglop
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sgoogle
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sgraph
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Slinear_solver
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Slp_data
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sport
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Ssat
	$(MKDIR) temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sutil
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples$Scpp
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples$Scsharp
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples$Scsharp$Ssolution
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples$Scsharp$Ssolution$SProperties
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples$Scom
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples$Scom$Sgoogle
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples$Scom$Sgoogle$Sortools
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples$Scom$Sgoogle$Sortools$Ssamples
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples$Sfsharp
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples$Sfsharp$Slib
	$(MKDIR) temp$S$(INSTALL_DIR)$Sexamples$Snetstandard
#credits
	$(COPY) LICENSE-2.0.txt temp$S$(INSTALL_DIR)
	$(COPY) tools$SREADME.cc.java.dotnet temp$S$(INSTALL_DIR)$SREADME
	$(COPY) tools$SMakefile.cc.java.dotnet temp$S$(INSTALL_DIR)$SMakefile

create_data_dirs:
	-$(DELREC) temp_data
	$(MKDIR) temp_data
	$(MKDIR) temp_data$S$(INSTALL_DIR)
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Set_jobshop
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Sflexible_jobshop
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Sjobshop
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Smultidim_knapsack
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Scvrptw
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Spdptw
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Sfill_a_pix
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Sminesweeper
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Srogo
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Ssurvo_puzzle
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Squasigroup_completion
	$(MKDIR) temp_data$S$(INSTALL_DIR)$Sexamples$Sdata$Sdiscrete_tomography
#credits
	$(COPY) LICENSE-2.0.txt temp_data$S$(INSTALL_DIR)

.PHONY: data_archive
data_archive: $(INSTALL_DIR)_data$(ARCHIVE_EXT)

$(INSTALL_DIR)_data$(ARCHIVE_EXT): create_data_dirs
ifeq ($(SYSTEM),win)
	tools$Star.exe -c -v \
--exclude *svn* \
--exclude *roadef* \
--exclude *vector_packing* \
--exclude *nsplib* \
examples\\data | tools$Star.exe xvm -C temp_data\\$(INSTALL_DIR)
	cd temp_data && ..$Stools$Szip.exe -r ..$S$(INSTALL_DIR)_data.zip $(INSTALL_DIR)
else
	tar -c -v \
--exclude *svn* \
--exclude *roadef* \
--exclude *vector_packing* \
--exclude *nsplib* \
examples/data | tar xvm -C temp_data/$(INSTALL_DIR)
	cd temp_data && tar -c -v -z --no-same-owner -f ..$S$(INSTALL_DIR)_data.tar.gz $(INSTALL_DIR)
endif
	-$(DELREC) temp_data

cc_archive: cc create_dirs
	$(COPY) $(LIB_DIR)$S$(LIB_PREFIX)cvrptw_lib.$L temp$S$(INSTALL_DIR)$Slib
	$(COPY) $(LIB_DIR)$S$(LIB_PREFIX)dimacs.$L temp$S$(INSTALL_DIR)$Slib
	$(COPY) $(LIB_DIR)$S$(LIB_PREFIX)ortools.$L temp$S$(INSTALL_DIR)$Slib
	$(COPY) $(LIB_DIR)$S$(LIB_PREFIX)fap.$L temp$S$(INSTALL_DIR)$Slib
	$(COPY) examples$Scpp$S*.cc temp$S$(INSTALL_DIR)$Sexamples$Scpp
	$(COPY) examples$Scpp$S*.h temp$S$(INSTALL_DIR)$Sexamples$Scpp
	$(COPY) ortools$Salgorithms$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Salgorithms
	$(COPY) ortools$Sbase$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sbase
	$(COPY) ortools$Sconstraint_solver$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sconstraint_solver
	$(COPY) ortools$Sgen$Sortools$Sconstraint_solver$S*.pb.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sconstraint_solver
	$(COPY) ortools$Sdata$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sdata
	$(COPY) ortools$Sgen$Sortools$Sdata$S*.pb.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sdata
	$(COPY) ortools$Sbop$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sbop
	$(COPY) ortools$Sgen$Sortools$Sbop$S*.pb.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sbop
	$(COPY) ortools$Sglop$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sglop
	$(COPY) ortools$Sgen$Sortools$Sglop$S*.pb.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sglop
	$(COPY) ortools$Sgraph$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sgraph
	$(COPY) ortools$Sgen$Sortools$Sgraph$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sgraph
	$(COPY) ortools$Slinear_solver$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Slinear_solver
	$(COPY) ortools$Slp_data$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Slp_data
	$(COPY) ortools$Sgen$Sortools$Slinear_solver$S*.pb.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Slinear_solver
	$(COPY) ortools$Sport$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sport
	$(COPY) ortools$Ssat$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Ssat
	$(COPY) ortools$Sgen$Sortools$Ssat$S*.pb.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Ssat
	$(COPY) ortools$Sutil$S*.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sutil
	$(COPY) ortools$Sgen$Sortools$Sutil$S*.pb.h temp$S$(INSTALL_DIR)$Sinclude$Sortools$Sutil
ifeq ($(SYSTEM),win)
	$(COPY) tools$Smake.exe temp$S$(INSTALL_DIR)
	$(COPY) tools$Swhich.exe temp$S$(INSTALL_DIR)
	cd temp$S$(INSTALL_DIR)$Sinclude && ..$S..$S..$Stools$Star.exe -C ..$S..$S..$Sdependencies$Sinstall$Sinclude -c -v gflags | ..$S..$S..$Stools$Star.exe xvm
	cd temp$S$(INSTALL_DIR)$Sinclude && ..$S..$S..$Stools$Star.exe -C ..$S..$S..$Sdependencies$Sinstall$Sinclude -c -v glog | ..$S..$S..$Stools$Star.exe xvm
	cd temp$S$(INSTALL_DIR)$Sinclude && ..$S..$S..$Stools$Star.exe -C ..$S..$S..$Sdependencies$Sinstall$Sinclude -c -v google | ..$S..$S..$Stools$Star.exe xvm
else
	cd temp$S$(INSTALL_DIR)$Sinclude && tar -C ..$S..$S..$Sdependencies$Sinstall$Sinclude -c -v gflags | tar xvm
	cd temp$S$(INSTALL_DIR)$Sinclude && tar -C ..$S..$S..$Sdependencies$Sinstall$Sinclude -c -v glog | tar xvm
	cd temp$S$(INSTALL_DIR)$Sinclude && tar -C ..$S..$S..$Sdependencies$Sinstall$Sinclude -c -v google | tar xvm
	cd temp$S$(INSTALL_DIR) && tar -C ..$S..$Sdependencies$Sinstall -c -v lib | tar xvm
  ifneq ($(wildcard dependencies/install/lib64),)
	cd temp$S$(INSTALL_DIR) && tar -C ..$S..$Sdependencies$Sinstall -c -v lib64 | tar xvm
  endif
endif

dotnet_archive: csharp create_dirs
	$(COPY) bin$SGoogle.Protobuf.dll temp$S$(INSTALL_DIR)$Sbin
	$(COPY) bin$S$(CLR_ORTOOLS_DLL_NAME).dll temp$S$(INSTALL_DIR)$Sbin
	$(COPY) examples$Scsharp$S*.cs temp$S$(INSTALL_DIR)$Sexamples$Scsharp
	$(COPY) examples$Sfsharp$S*fsx temp$S$(INSTALL_DIR)$Sexamples$Sfsharp
	$(COPY) examples$Sfsharp$SREADME.md temp$S$(INSTALL_DIR)$Sexamples$Sfsharp
	$(COPY) examples$Scsharp$Ssolution$SProperties$S*.cs temp$S$(INSTALL_DIR)$Sexamples$Scsharp$Ssolution$SProperties
	-$(COPY) examples$Sfsharp$Slib$S* temp$S$(INSTALL_DIR)$Sexamples$Sfsharp$Slib
ifeq ($(SYSTEM),win)
	$(COPY) examples$Scsharp$SCsharp_examples.sln temp$S$(INSTALL_DIR)$Sexamples$Scsharp
	$(COPY) examples$Scsharp$Ssolution$S*.csproj temp$S$(INSTALL_DIR)$Sexamples$Scsharp$Ssolution
	$(COPY) examples$Scsharp$Ssolution$Sapp.config temp$S$(INSTALL_DIR)$Sexamples$Scsharp$Ssolution
else
	$(COPY) lib$Slib$(CLR_ORTOOLS_DLL_NAME).so temp$S$(INSTALL_DIR)$Sbin
endif

netstandard_archive: NET_STANDARD_EXAMPLES = $(wildcard examples/csharp/*.cs)
netstandard_archive: netstandard_example_archive
	$(COPY) bin$S$(NETSTANDARD_ORTOOLS_DLL_NAME).dll temp$S$(INSTALL_DIR)$Sbin$S
	$(COPY) bin$S$(NETSTANDARD_ORTOOLS_IMPORT_DLL_NAME).$(SWIG_DOTNET_LIB_SUFFIX) temp$S$(INSTALL_DIR)$Sbin$S
	$(COPY) bin$S$(NETSTANDARD_ORTOOLS_DLL_NAME).$(OR_TOOLS_VERSION).nupkg temp$S$(INSTALL_DIR)$Sbin$S
	$(COPY) tools$SREADME.netstandard temp$S$(INSTALL_DIR)$Sexamples$Snetstandard

netstandard_example_archive:
	$(foreach file, $(NET_STANDARD_EXAMPLES), $(call netstandard_example_archive_copy,$(file))) :

define netstandard_example_archive_copy
	$(MKDIR_P) temp$S$(INSTALL_DIR)$Sexamples$Snetstandard$S$(basename $(notdir $(1))) &&\
	$(COPY) tools$Snetstandard$Snuget.config temp$S$(INSTALL_DIR)$Sexamples$Snetstandard$S$(basename $(notdir $(1))) &&\
	$(COPY) tools$Snetstandard$Sexample.csproj temp$S$(INSTALL_DIR)$Sexamples$Snetstandard$S$(basename $(notdir $(1))) &&\
	$(COPY) examples$Scsharp$S$(notdir $(1)) temp$S$(INSTALL_DIR)$Sexamples$Snetstandard$S$(basename $(notdir $(1)))$S &&
endef

java_archive: java create_dirs
	$(COPY) lib$S*.jar temp$S$(INSTALL_DIR)$Slib
	$(COPY) lib$S$(LIB_PREFIX)jni*.$(JNI_LIB_EXT) temp$S$(INSTALL_DIR)$Slib
	$(COPY) examples$Scom$Sgoogle$Sortools$Ssamples$S*.java temp$S$(INSTALL_DIR)$Sexamples$Scom$Sgoogle$Sortools$Ssamples

TEMP_FZ_DIR = temp_fz
fz_archive: cc fz
	-$(DELREC) $(TEMP_FZ_DIR)
	mkdir $(TEMP_FZ_DIR)
	mkdir $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)
	mkdir $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Sbin
	mkdir $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Slib
	mkdir $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Sshare
	mkdir $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Sshare$Sminizinc_cp
	mkdir $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Sshare$Sminizinc_sat
	mkdir $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Sexamples
	$(COPY) LICENSE-2.0.txt $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)
	$(COPY) bin$Sfz$E $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Sbin$Sfzn-or-tools$E
	$(COPY) $(LIB_DIR)$S$(LIB_PREFIX)ortools.$L $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Slib
	$(COPY) $(LIB_DIR)$S$(LIB_PREFIX)fz.$L $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Slib
	$(COPY) ortools$Sflatzinc$Smznlib_cp$S* $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Sshare$Sminizinc_cp
	$(COPY) ortools$Sflatzinc$Smznlib_sat$S* $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Sshare$Sminizinc_sat
	$(COPY) examples$Sflatzinc$S* $(TEMP_FZ_DIR)$S$(FZ_INSTALL_DIR)$Sexamples
ifeq ($(SYSTEM),win)
	cd $(TEMP_FZ_DIR) && ..$Stools$Szip.exe -r ..$S$(FZ_INSTALL_DIR).zip $(FZ_INSTALL_DIR)
else
	cd $(TEMP_FZ_DIR) && tar cvzf ..$S$(FZ_INSTALL_DIR).tar.gz $(FZ_INSTALL_DIR)
endif
	-$(DELREC) $(TEMP_FZ_DIR)

.PHONY: test_archive
test_archive: $(INSTALL_DIR)$(ARCHIVE_EXT)
	-$(DELREC) temp
	$(MKDIR) temp
#this is to make sure the archive tests don't use the root libraries
	$(RENAME) lib lib2
ifeq ($(SYSTEM),win)
	tools$Sunzip.exe $(INSTALL_DIR).zip -d temp
else
	tar -xvf $(INSTALL_DIR).tar.gz -C temp
endif
	cd temp$S$(INSTALL_DIR) && $(MAKE) test && cd ../.. && $(RENAME) lib2 lib && echo "archive test succeeded" || ( cd ../.. && $(RENAME) lib2 lib && echo "archive test failed" && exit 1)

TEMP_FZ_TEST_DIR = temp_fz_test
test_fz_archive: $(FZ_INSTALL_DIR)$(ARCHIVE_EXT)
	-$(DELREC) $(TEMP_FZ_TEST_DIR)
	$(MKDIR) $(TEMP_FZ_TEST_DIR)
#this is to make sure the archive tests don't use the root libraries
	$(RENAME) lib lib2
ifeq ($(SYSTEM),win)
	tools$Sunzip.exe $(FZ_INSTALL_DIR).zip -d $(TEMP_FZ_TEST_DIR)
else
	tar -x -v -f $(FZ_INSTALL_DIR).tar.gz -C $(TEMP_FZ_TEST_DIR)
endif
	cd $(TEMP_FZ_TEST_DIR)$S$(FZ_INSTALL_DIR) && .$Sbin$S$(FZ_EXE) examples$Scircuit_test.fzn && cd ../.. && $(RENAME) lib2 lib && echo "fz archive test succeeded" || ( cd ../.. && $(RENAME) lib2 lib && echo "fz archive test failed" && exit 1)


ifeq "$(PYTHON3)" "true"
    build_release: clean python test_python
    pre_release: pypi_archive
    release: pypi_upload
else #platform check

ifeq ($(SYSTEM),win)

ifeq "$(VISUAL_STUDIO_YEAR)" "2013"
    build_release: clean all test
    pre_release: archive test_archive
    release:
else
ifeq "$(VISUAL_STUDIO_YEAR)" "2015"
    build_release: clean all test fz
    pre_release: archive test_archive fz_archive test_fz_archive python_examples_archive pypi_archive nuget_archive
    release: pypi_upload nuget_upload
endif #ifeq "$(VISUAL_STUDIO_YEAR)" "2015"

endif # ifeq"$(VISUAL_STUDIO_YEAR)" "2013"

else # unix

ifeq "$(PLATFORM)" "LINUX"
ifeq "$(DISTRIBUTION_NUMBER)" "14.04"
    build_release: clean all test fz
    pre_release: archive test_archive fz_archive test_fz_archive python_examples_archive pypi_archive
    release: pypi_upload
else
ifeq "$(DISTRIBUTION_NUMBER)" "16.04"
    build_release: clean all test fz
    pre_release: archive test_archive fz_archive test_fz_archive
    release:
endif # ifeq "$(DISTRIBUTION_NUMBER)" "16.04"
endif # ifeq "$(DISTRIBUTION_NUMBER)" "14.04"
endif # ifeq "$(PLATFORM)" "LINUX"

ifeq "$(PLATFORM)" "MACOSX"
    build_release: clean all test fz
    pre_release: archive test_archive fz_archive test_fz_archive pypi_archive
    release: pypi_upload
endif #ifeq "$(PLATFORM)" "MACOSX"

endif #ifeq ($(SYSTEM),win)
endif #ifeq "$(PYTHON3)" "true"

.PHONY: detect_archive # Show variables used to build archive OR-Tools.
detect_archive:
	@echo Relevant info for the archive build:
	@echo INSTALL_DIR = $(INSTALL_DIR)
ifeq ($(SYSTEM),win)
	@echo off & echo(
else
	@echo
endif
