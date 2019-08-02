Return-Path: <SRS0=d5Cv=V6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB4BC433FF
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Aug 2019 20:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6713B20880
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Aug 2019 20:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437044AbfHBUrI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Aug 2019 16:47:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:4591 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbfHBUrH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Aug 2019 16:47:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 13:47:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,339,1559545200"; 
   d="scan'208";a="167344613"
Received: from psathya-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.36.242])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2019 13:46:59 -0700
Date:   Fri, 2 Aug 2019 23:46:53 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v21 24/28] selftests/x86: Add a selftest for SGX
Message-ID: <20190802204653.hsfd55zu2pp5vun7@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-25-jarkko.sakkinen@linux.intel.com>
 <e7b51875-c190-bab6-28ec-0eaa6caf2955@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7b51875-c190-bab6-28ec-0eaa6caf2955@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 17, 2019 at 03:37:03PM -0700, Xing, Cedric wrote:
> On 7/13/2019 10:08 AM, Jarkko Sakkinen wrote:
> > Add a selftest for SGX. It is a trivial test where a simple enclave
> > copies one 64-bit word of memory between two memory locations given to
> > the enclave as arguments.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >   tools/testing/selftests/x86/Makefile          |  10 +
> >   tools/testing/selftests/x86/sgx/Makefile      |  48 ++
> >   tools/testing/selftests/x86/sgx/defines.h     |  39 ++
> >   tools/testing/selftests/x86/sgx/encl.c        |  20 +
> >   tools/testing/selftests/x86/sgx/encl.lds      |  33 ++
> >   .../selftests/x86/sgx/encl_bootstrap.S        |  94 ++++
> >   tools/testing/selftests/x86/sgx/encl_piggy.S  |  18 +
> >   tools/testing/selftests/x86/sgx/encl_piggy.h  |  14 +
> >   tools/testing/selftests/x86/sgx/main.c        | 301 +++++++++++
> >   tools/testing/selftests/x86/sgx/sgx_call.S    |  49 ++
> >   tools/testing/selftests/x86/sgx/sgxsign.c     | 508 ++++++++++++++++++
> >   .../testing/selftests/x86/sgx/signing_key.pem |  39 ++
> >   12 files changed, 1173 insertions(+)
> >   create mode 100644 tools/testing/selftests/x86/sgx/Makefile
> >   create mode 100644 tools/testing/selftests/x86/sgx/defines.h
> >   create mode 100644 tools/testing/selftests/x86/sgx/encl.c
> >   create mode 100644 tools/testing/selftests/x86/sgx/encl.lds
> >   create mode 100644 tools/testing/selftests/x86/sgx/encl_bootstrap.S
> >   create mode 100644 tools/testing/selftests/x86/sgx/encl_piggy.S
> >   create mode 100644 tools/testing/selftests/x86/sgx/encl_piggy.h
> >   create mode 100644 tools/testing/selftests/x86/sgx/main.c
> >   create mode 100644 tools/testing/selftests/x86/sgx/sgx_call.S
> >   create mode 100644 tools/testing/selftests/x86/sgx/sgxsign.c
> >   create mode 100644 tools/testing/selftests/x86/sgx/signing_key.pem
> > 
> > diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
> > index fa07d526fe39..a1831406fd01 100644
> > --- a/tools/testing/selftests/x86/Makefile
> > +++ b/tools/testing/selftests/x86/Makefile
> > @@ -1,4 +1,7 @@
> >   # SPDX-License-Identifier: GPL-2.0
> > +
> > +SUBDIRS_64 := sgx
> > +
> >   all:
> >   include ../lib.mk
> > @@ -68,6 +71,13 @@ all_32: $(BINARIES_32)
> >   all_64: $(BINARIES_64)
> > +all_64: $(SUBDIRS_64)
> 
> $(SUBDIRS_64) aren't targets. No need for all_64 to depend on them.
> 
> > +	@for DIR in $(SUBDIRS_64); do			\
> > +		BUILD_TARGET=$(OUTPUT)/$$DIR;		\
> > +		mkdir $$BUILD_TARGET  -p;		\
> > +		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;	\
> 
> Please use $(MAKE), otherwise command line options cannot be passed onto
> sub-makes.
> 
> > +	done
> 
> The above only builds but will not run SGX tests.
> 
> Also, 'clean' target will not descend into sgx folder either.
> 
> > +
> >   EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
> >   $(BINARIES_32): $(OUTPUT)/%_32: %.c
> > diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
> > new file mode 100644
> > index 000000000000..10136b73096b
> > --- /dev/null
> > +++ b/tools/testing/selftests/x86/sgx/Makefile
> > @@ -0,0 +1,48 @@
> > +top_srcdir = ../../../../..
> > +
> > +include ../../lib.mk
> > +
> > +HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC -z noexecstack
> > +ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
> > +	       -fno-stack-protector -mrdrnd $(INCLUDES)
> > +
> > +TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
> > +all_64: $(TEST_CUSTOM_PROGS)
> > +
> > +$(TEST_CUSTOM_PROGS): $(OUTPUT)/main.o $(OUTPUT)/sgx_call.o \
> > +		      $(OUTPUT)/encl_piggy.o
> > +	$(CC) $(HOST_CFLAGS) -o $@ $^
> > +
> > +$(OUTPUT)/main.o: main.c
> > +	$(CC) $(HOST_CFLAGS) -c $< -o $@
> 
> .o files don't have to be generated/kept. And to be consistent with other
> selftests, please don't generate/keep them.
> 
> > +
> > +$(OUTPUT)/sgx_call.o: sgx_call.S
> > +	$(CC) $(HOST_CFLAGS) -c $< -o $@
> > +
> > +$(OUTPUT)/encl_piggy.o: $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
> > +	$(CC) $(HOST_CFLAGS) -c encl_piggy.S -o $@
> 
> Without -I, the above command breaks when "O=<target dir>" is specified.
> 
> > +
> > +$(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf $(OUTPUT)/sgxsign
> > +	objcopy --remove-section=.got.plt -O binary $< $@
> 
> .got.plt section will never be present for statically linked binaries.
> 
> > +
> > +$(OUTPUT)/encl.elf: $(OUTPUT)/encl.o $(OUTPUT)/encl_bootstrap.o
> > +	$(CC) $(ENCL_CFLAGS) -T encl.lds -o $@ $^
> 
> Please fix the warning of ".note.gnu.build-id section discarded".
> 
> > +
> > +$(OUTPUT)/encl.o: encl.c
> > +	$(CC) $(ENCL_CFLAGS) -c $< -o $@
> > +
> > +$(OUTPUT)/encl_bootstrap.o: encl_bootstrap.S
> > +	$(CC) $(ENCL_CFLAGS) -c $< -o $@
> > +
> > +$(OUTPUT)/encl.ss: $(OUTPUT)/encl.bin  $(OUTPUT)/sgxsign
> > +	$(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
> > +
> > +$(OUTPUT)/sgxsign: sgxsign.c
> > +	$(CC) -o $@ $< -lcrypto
> > +
> > +EXTRA_CLEAN := $(OUTPUT)/sgx-selftest $(OUTPUT)/sgx-selftest.o \
> > +	       $(OUTPUT)/sgx_call.o $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss \
> > +	       $(OUTPUT)/encl.elf $(OUTPUT)/encl.o $(OUTPUT)/encl_bootstrap.o \
> > +	       $(OUTPUT)/sgxsign
> > +
> 
> encl_piggy.o, main.o and test_sgx are not cleaned.
> 
> > +.PHONY: clean

Thanks. Probably have to construct a patch set for selftest fixes
with one patch for each issue.

/Jarkko
