Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47985C742A5
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18CF721019
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbfGLDTc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 23:19:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:45926 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728899AbfGLDTc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 23:19:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 20:19:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="341578693"
Received: from gonegri-mobl.ger.corp.intel.com (HELO localhost) ([10.252.48.192])
  by orsmga005.jf.intel.com with ESMTP; 11 Jul 2019 20:19:27 -0700
Date:   Fri, 12 Jul 2019 06:19:25 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        kai.svahn@intel.com, kai.huang@intel.com
Subject: Re: [RFC PATCH v2 1/3] selftests/x86: Fixed Makefile for SGX selftest
Message-ID: <20190712031925.32dqi3v3jetojaju@linux.intel.com>
References: <cover.1555965327.git.cedric.xing@intel.com>
 <20190424062623.4345-2-cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424062623.4345-2-cedric.xing@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 23, 2019 at 11:26:21PM -0700, Cedric Xing wrote:
> The original x86/sgx/Makefile doesn't work when 'x86/sgx' is specified as the
> test target. This patch fixes that problem, along with minor changes to the
> dependencies between 'x86' and 'x86/sgx' in selftests/x86/Makefile.
> 
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> ---
>  tools/testing/selftests/x86/Makefile     | 12 +++----
>  tools/testing/selftests/x86/sgx/Makefile | 45 +++++++++---------------
>  2 files changed, 22 insertions(+), 35 deletions(-)
> 
> diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
> index 4fc9a42f56ea..1294c5f5b6ca 100644
> --- a/tools/testing/selftests/x86/Makefile
> +++ b/tools/testing/selftests/x86/Makefile
> @@ -70,11 +70,11 @@ all_32: $(BINARIES_32)
>  
>  all_64: $(BINARIES_64)
>  
> -all_64: $(SUBDIRS_64)
> -	@for DIR in $(SUBDIRS_64); do			\
> -		BUILD_TARGET=$(OUTPUT)/$$DIR;		\
> -		mkdir $$BUILD_TARGET  -p;		\
> -		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;	\
> +all_64: | $(SUBDIRS_64)
> +	@for DIR in $|; do					\
> +		BUILD_TARGET=$(OUTPUT)/$$DIR;			\
> +		mkdir $$BUILD_TARGET  -p;			\
> +		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$DIR $@;	\

This is not fix for anything. It is change in semantics. This diff
should be isolated to its own commit as you are changing something
outside of SGX scope.

>  	done
>  
>  EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
> @@ -90,7 +90,7 @@ ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)
>  all: warn_32bit_failure
>  
>  warn_32bit_failure:
> -	@echo "Warning: you seem to have a broken 32-bit build" 2>&1; 	\
> +	@echo "Warning: you seem to have a broken 32-bit build" 2>&1;	\

Please clean this up.

>  	echo "environment.  This will reduce test coverage of 64-bit" 2>&1; \
>  	echo "kernels.  If you are using a Debian-like distribution," 2>&1; \
>  	echo "try:"; 2>&1; \
> diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
> index 1fd6f2708e81..3af15d7c8644 100644
> --- a/tools/testing/selftests/x86/sgx/Makefile
> +++ b/tools/testing/selftests/x86/sgx/Makefile
> @@ -2,47 +2,34 @@ top_srcdir = ../../../../..
>  
>  include ../../lib.mk
>  
> -HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC
> -ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
> +ifeq ($(shell $(CC) -dumpmachine | cut --delimiter=- -f1),x86_64)
> +all: all_64
> +endif
> +
> +HOST_CFLAGS := -Wall -Werror -g $(INCLUDES)
> +ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIE \
>  	       -fno-stack-protector -mrdrnd $(INCLUDES)
>  
>  TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
>  all_64: $(TEST_CUSTOM_PROGS)
>  
> -$(TEST_CUSTOM_PROGS): $(OUTPUT)/main.o $(OUTPUT)/sgx_call.o \
> -		      $(OUTPUT)/encl_piggy.o
> +$(TEST_CUSTOM_PROGS): main.c sgx_call.S $(OUTPUT)/encl_piggy.o
>  	$(CC) $(HOST_CFLAGS) -o $@ $^
>  
> -$(OUTPUT)/main.o: main.c
> -	$(CC) $(HOST_CFLAGS) -c $< -o $@
> -
> -$(OUTPUT)/sgx_call.o: sgx_call.S
> -	$(CC) $(HOST_CFLAGS) -c $< -o $@
> -
> -$(OUTPUT)/encl_piggy.o: $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
> -	$(CC) $(HOST_CFLAGS) -c encl_piggy.S -o $@
> +$(OUTPUT)/encl_piggy.o: encl_piggy.S $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
> +	$(CC) $(HOST_CFLAGS) -I$(OUTPUT) -c $< -o $@
>  
> -$(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf $(OUTPUT)/sgxsign
> +$(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf
>  	objcopy --remove-section=.got.plt -O binary $< $@
>  
> -$(OUTPUT)/encl.elf: $(OUTPUT)/encl.o $(OUTPUT)/encl_bootstrap.o
> -	$(CC) $(ENCL_CFLAGS) -T encl.lds -o $@ $^
> +$(OUTPUT)/encl.elf: encl.lds encl.c encl_bootstrap.S
> +	$(CC) $(ENCL_CFLAGS) -T $^ -o $@
>  
> -$(OUTPUT)/encl.o: encl.c
> -	$(CC) $(ENCL_CFLAGS) -c $< -o $@
> -
> -$(OUTPUT)/encl_bootstrap.o: encl_bootstrap.S
> -	$(CC) $(ENCL_CFLAGS) -c $< -o $@
> -
> -$(OUTPUT)/encl.ss: $(OUTPUT)/encl.bin  $(OUTPUT)/sgxsign
> -	$(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
> +$(OUTPUT)/encl.ss: $(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin
> +	$^ $@
>  
>  $(OUTPUT)/sgxsign: sgxsign.c
>  	$(CC) -o $@ $< -lcrypto
>  
> -EXTRA_CLEAN := $(OUTPUT)/sgx-selftest $(OUTPUT)/sgx-selftest.o \
> -	       $(OUTPUT)/sgx_call.o $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss \
> -	       $(OUTPUT)/encl.elf $(OUTPUT)/encl.o $(OUTPUT)/encl_bootstrap.o \
> -	       $(OUTPUT)/sgxsign
> -
> -.PHONY: clean
> +EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(addprefix $(OUTPUT)/,	\
> +		encl.elf encl.bin encl.ss encl_piggy.o sgxsign)
> -- 
> 2.17.1
> 

What are all these changes to the makefile? I don't see mention of them
in the commit message.

/Jarkko
