Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB19BC10F14
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 18:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0FEF2070B
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 18:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfJHSRz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 14:17:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:55600 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfJHSRz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 14:17:55 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 11:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,272,1566889200"; 
   d="scan'208";a="393428590"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 08 Oct 2019 11:17:54 -0700
Date:   Tue, 8 Oct 2019 11:17:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v22 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191008181752.GE14020@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-13-jarkko.sakkinen@linux.intel.com>
 <20191008175924.GN14765@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191008175924.GN14765@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 08, 2019 at 07:59:24PM +0200, Borislav Petkov wrote:
> > diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> > new file mode 100644
> > index 000000000000..c45eeed68144
> > --- /dev/null
> > +++ b/arch/x86/include/uapi/asm/sgx.h
> > @@ -0,0 +1,55 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */
> 
> checkpatch is bitching for some reason, I guess it doesn't like the
> "WITH" thing or so:
> 
> WARNING: 'SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */' is not supported in LICENSES/...
> #98: FILE: arch/x86/include/uapi/asm/sgx.h:1:
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */
> 
> WARNING: 'SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause WITH Linux-syscall-note */' is not supported in LICENSES/...
> #159: FILE: arch/x86/include/uapi/asm/sgx_errno.h:1:
> +/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause WITH Linux-syscall-note */
> 
> And building this fails:
> 
> arch/x86/kernel/cpu/sgx/encl.c: In function ‘sgx_mmu_notifier_release’:
> arch/x86/kernel/cpu/sgx/encl.c:77:3: error: implicit declaration of function ‘mmu_notifier_unregister_no_release’; did you mean ‘mmu_notifier_unregister’? [-Werror=implicit-function-declaration]
>    mmu_notifier_unregister_no_release(mn, mm);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    mmu_notifier_unregister
> arch/x86/kernel/cpu/sgx/encl.c:78:3: error: implicit declaration of function ‘mmu_notifier_call_srcu’; did you mean ‘mmu_notifier_release’? [-Werror=implicit-function-declaration]
>    mmu_notifier_call_srcu(&encl_mm->rcu,
>    ^~~~~~~~~~~~~~~~~~~~~~
>    mmu_notifier_release
> cc1: some warnings being treated as errors
> make[4]: *** [scripts/Makefile.build:265: arch/x86/kernel/cpu/sgx/encl.o] Error 1
> make[4]: *** Waiting for unfinished jobs....
> make[3]: *** [scripts/Makefile.build:509: arch/x86/kernel/cpu/sgx] Error 2
> make[2]: *** [scripts/Makefile.build:509: arch/x86/kernel/cpu] Error 2
> make[1]: *** [scripts/Makefile.build:509: arch/x86/kernel] Error 2
> make: *** [Makefile:1670: arch/x86] Error 2
> make: *** Waiting for unfinished jobs....
> 
> Got a fixed version which I can review instead?

The build error is due to mmu notifier changes that are going into 5.4,
whereas I believe this is based on 5.3.

Jarkko has rebased to 5.4-rc1 and addressed the mmu notifier issue, but I
don't know exact status of his branch.  I'd prefer not to send you a borked
patch.

There are already a handful of driver changes on our todo list for v23, as
well as the vDSO and selftest updates.  What if you stop here for now and
restart when Jarkko sends v23?  In theory that'll happen later this week.
