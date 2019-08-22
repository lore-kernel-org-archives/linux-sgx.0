Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FC8C3A59E
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68F3221848
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfHVDmF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 23:42:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:42773 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbfHVDmF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 23:42:05 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 20:42:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,415,1559545200"; 
   d="scan'208";a="169629880"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 21 Aug 2019 20:42:04 -0700
Date:   Wed, 21 Aug 2019 20:42:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com
Subject: Re: [PATCH v3 7/7] selftests/x86: Recurse into subdirectories
Message-ID: <20190822034204.GR29345@linux.intel.com>
References: <20190819132830.9056-1-jarkko.sakkinen@linux.intel.com>
 <20190819132830.9056-8-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819132830.9056-8-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 19, 2019 at 04:28:30PM +0300, Jarkko Sakkinen wrote:
> Recurse into a list of subdirectories defined by SUBDIRS when running
> x86 selftests. Override run_tests, install, emit_tests and clean
> targets to implement this behaviour.

The code looks good (which doesn't say much, my Makefile knowledge is
garbage), but the result is a bit odd.  x86/sgx doesn't implement
emit_tests (or at least test_sgx doesn't show up), while the rest of the
x86 tests don't support install.

AFAICT the Makefile is itself weird; it's definitely different than other
selftests Makfiles.  I don't see any reason to delay this patch, but it
feels like something here needs to be cleaned up.

> A possible alternative would be to add "x86/sgx" to TARGETS. However,
> this would be problematic because detecting 64-bit build would have
> to duplicated.
> 
> The implementation is derived from the makefiles of powerpc and sparc64
> selftests.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  tools/testing/selftests/x86/Makefile | 44 ++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
> index fa07d526fe39..80571bac8ed5 100644
> --- a/tools/testing/selftests/x86/Makefile
> +++ b/tools/testing/selftests/x86/Makefile
> @@ -10,6 +10,8 @@ CAN_BUILD_I386 := $(shell ./check_cc.sh $(CC) trivial_32bit_program.c -m32)
>  CAN_BUILD_X86_64 := $(shell ./check_cc.sh $(CC) trivial_64bit_program.c)
>  CAN_BUILD_WITH_NOPIE := $(shell ./check_cc.sh $(CC) trivial_program.c -no-pie)
>  
> +SUBDIRS := sgx
> +
>  TARGETS_C_BOTHBITS := single_step_syscall sysret_ss_attrs syscall_nt test_mremap_vdso \
>  			check_initial_reg_state sigreturn iopl mpx-mini-test ioperm \
>  			protection_keys test_vdso test_vsyscall mov_ss_trap \
> @@ -59,6 +61,48 @@ endif
>  
>  ifeq ($(CAN_BUILD_X86_64),1)
>  all: all_64
> +	@for DIR in $(SUBDIRS); do \
> +		BUILD_TARGET=$(OUTPUT)/$$DIR; \
> +		mkdir $$BUILD_TARGET  -p; \
> +		make OUTPUT=$$BUILD_TARGET -C $$DIR $@; \
> +	done
> +
> +DEFAULT_RUN_TESTS := $(RUN_TESTS)
> +override define RUN_TESTS
> +	$(DEFAULT_RUN_TESTS)
> +	@for TARGET in $(SUBDIRS); do \
> +		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
> +		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests; \
> +	done;
> +endef
> +
> +DEFAULT_INSTALL_RULE := $(INSTALL_RULE)
> +override define INSTALL_RULE
> +	$(DEFAULT_INSTALL_RULE)
> +	@for TARGET in $(SUBDIRS); do \
> +		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
> +		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install; \
> +	done;
> +endef
> +
> +DEFAULT_EMIT_TESTS := $(EMIT_TESTS)
> +override define EMIT_TESTS
> +	$(DEFAULT_EMIT_TESTS)
> +	@for TARGET in $(SUBDIRS); do \
> +		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
> +		$(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests; \
> +	done;
> +endef
> +
> +DEFAULT_CLEAN := $(CLEAN)
> +override define CLEAN
> +	$(DEFAULT_CLEAN)
> +	@for TARGET in $(SUBDIRS); do \
> +		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
> +		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean; \
> +	done;
> +endef
> +
>  TEST_PROGS += $(BINARIES_64)
>  EXTRA_CFLAGS += -DCAN_BUILD_64
>  $(foreach t,$(TARGETS_C_64BIT_ALL),$(eval $(call gen-target-rule-64,$(t))))
> -- 
> 2.20.1
> 
