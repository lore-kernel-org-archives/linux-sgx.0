Return-Path: <SRS0=RGqr=3Y=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401A3C3524D
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Feb 2020 15:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D15D217BA
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Feb 2020 15:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgBDPLo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Feb 2020 10:11:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:47959 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbgBDPLo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Feb 2020 10:11:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 07:11:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,402,1574150400"; 
   d="scan'208";a="235192470"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 04 Feb 2020 07:11:43 -0800
Date:   Tue, 4 Feb 2020 07:11:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v25 00/21] Intel SGX foundations
Message-ID: <20200204151143.GA5663@linux.intel.com>
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 04, 2020 at 08:05:24AM +0200, Jarkko Sakkinen wrote:
>  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
>  Documentation/x86/index.rst                   |   1 +
>  Documentation/x86/sgx.rst                     | 177 ++++
>  arch/x86/Kconfig                              |  14 +
>  arch/x86/entry/vdso/Makefile                  |   8 +-
>  arch/x86/entry/vdso/extable.c                 |  46 +
>  arch/x86/entry/vdso/extable.h                 |  29 +
>  arch/x86/entry/vdso/vdso-layout.lds.S         |   9 +-
>  arch/x86/entry/vdso/vdso.lds.S                |   1 +
>  arch/x86/entry/vdso/vdso2c.h                  |  58 +-
>  arch/x86/entry/vdso/vsgx_enter_enclave.S      | 187 ++++
>  arch/x86/include/asm/cpufeature.h             |   5 +-
>  arch/x86/include/asm/cpufeatures.h            |   8 +-
>  arch/x86/include/asm/disabled-features.h      |  18 +-
>  arch/x86/include/asm/msr-index.h              |   8 +
>  arch/x86/include/asm/required-features.h      |   2 +-
>  arch/x86/include/asm/traps.h                  |   1 +
>  arch/x86/include/asm/vdso.h                   |   5 +
>  arch/x86/include/uapi/asm/sgx.h               | 114 +++
>  arch/x86/kernel/cpu/Makefile                  |   1 +
>  arch/x86/kernel/cpu/common.c                  |   4 +
>  arch/x86/kernel/cpu/feat_ctl.c                |  29 +-
>  arch/x86/kernel/cpu/sgx/Makefile              |   6 +
>  arch/x86/kernel/cpu/sgx/arch.h                | 395 +++++++++
>  arch/x86/kernel/cpu/sgx/driver.c              | 209 +++++
>  arch/x86/kernel/cpu/sgx/driver.h              |  32 +
>  arch/x86/kernel/cpu/sgx/encl.c                | 750 ++++++++++++++++
>  arch/x86/kernel/cpu/sgx/encl.h                | 127 +++
>  arch/x86/kernel/cpu/sgx/encls.h               | 239 ++++++
>  arch/x86/kernel/cpu/sgx/ioctl.c               | 810 ++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/main.c                | 280 ++++++
>  arch/x86/kernel/cpu/sgx/reclaim.c             | 463 ++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h                 | 108 +++
>  arch/x86/kernel/traps.c                       |  14 +
>  arch/x86/mm/fault.c                           |  45 +-
>  include/linux/mm.h                            |   2 +
>  mm/mprotect.c                                 |  14 +-
>  tools/arch/x86/include/asm/cpufeatures.h      |   7 +-
>  tools/testing/selftests/x86/Makefile          |  44 +
>  tools/testing/selftests/x86/sgx/.gitignore    |   3 +
>  tools/testing/selftests/x86/sgx/Makefile      |  48 ++
>  tools/testing/selftests/x86/sgx/defines.h     |  17 +
>  tools/testing/selftests/x86/sgx/encl.c        |  20 +
>  tools/testing/selftests/x86/sgx/encl.lds      |  34 +
>  .../selftests/x86/sgx/encl_bootstrap.S        |  94 ++
>  tools/testing/selftests/x86/sgx/main.c        | 379 ++++++++
>  tools/testing/selftests/x86/sgx/sgx_call.S    |  66 ++
>  tools/testing/selftests/x86/sgx/sgx_call.h    |  14 +
>  tools/testing/selftests/x86/sgx/sgxsign.c     | 493 +++++++++++
>  .../testing/selftests/x86/sgx/signing_key.pem |  39 +
>  50 files changed, 5447 insertions(+), 31 deletions(-)

Missing the MAINTAINERS update.
