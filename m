Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9D4C4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 12:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BAAE23772
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 12:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgIXMJZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 08:09:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:63823 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727480AbgIXMJL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 08:09:11 -0400
IronPort-SDR: 9oTAm7UcXe1As+PWNo/efOZ1M1CJ4HdGXvKWOA7P2wIrHU4yRKiPN3DpketLAmEND8bhgvmaJF
 yGbjkt7CJJWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="245974450"
X-IronPort-AV: E=Sophos;i="5.77,297,1596524400"; 
   d="scan'208";a="245974450"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 05:09:10 -0700
IronPort-SDR: 8yCgsq+RjHX7mBh7WAoWKVvOahQ17K17FP+qkvUHjSRHT2JByNe1eLWyIZNp2jTP1OyHQL+xco
 Y2T/69BUxapg==
X-IronPort-AV: E=Sophos;i="5.77,297,1596524400"; 
   d="scan'208";a="486878220"
Received: from mkoeck-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.48.209])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 05:09:03 -0700
Date:   Thu, 24 Sep 2020 15:09:01 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 18/24] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20200924120851.GE56811@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-19-jarkko.sakkinen@linux.intel.com>
 <20200923220712.GU28545@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923220712.GU28545@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 12:07:12AM +0200, Borislav Petkov wrote:
> On Tue, Sep 15, 2020 at 02:28:36PM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > The basic concept and implementation is very similar to the kernel's
> > exception fixup mechanism.  The key differences are that the kernel
> > handler is hardcoded and the fixup entry addresses are relative to
> > the overall table as opposed to individual entries.
> 
> ...
> 
> This gist of this commit message should be also in
> Documentation/x86/sgx.rst
> 
> And I already said the same thing during v33 review:
> 
> "That is a very good explanation and I would prefer if it would be in a
> sgx-specific README or so instead of it getting lost in git..."
> 
> ...

This is not technically SGX specific patch. Is SGX documentation the
correct place for this?

> > diff --git a/arch/x86/entry/vdso/extable.h b/arch/x86/entry/vdso/extable.h
> > new file mode 100644
> > index 000000000000..aafdac396948
> > --- /dev/null
> > +++ b/arch/x86/entry/vdso/extable.h
> > @@ -0,0 +1,29 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __VDSO_EXTABLE_H
> > +#define __VDSO_EXTABLE_H
> > +
> > +/*
> > + * Inject exception fixup for vDSO code.  Unlike normal exception fixup,
> > + * vDSO uses a dedicated handler the addresses are relative to the overall
> > + * exception table, not each individual entry.
> > + */
> > +#ifdef __ASSEMBLY__
> > +#define _ASM_VDSO_EXTABLE_HANDLE(from, to)	\
> > +	ASM_VDSO_EXTABLE_HANDLE from to
> > +
> > +.macro ASM_VDSO_EXTABLE_HANDLE from:req to:req
> > +	.pushsection __ex_table, "a"
> > +	.long (\from) - __ex_table
> > +	.long (\to) - __ex_table
> > +	.popsection
> > +.endm
> > +#else
> > +#define _ASM_VDSO_EXTABLE_HANDLE(from, to)	\
> > +	".pushsection __ex_table, \"a\"\n"      \
> > +	".long (" #from ") - __ex_table\n"      \
> > +	".long (" #to ") - __ex_table\n"        \
> > +	".popsection\n"
> > +#endif
> > +
> > +#endif /* __VDSO_EXTABLE_H */
> > +
> 
> Also from last time:
> 
> .git/rebase-apply/patch:122: new blank line at EOF.
> +

From checkpatch I only get:

ERROR: Macros with complex values should be enclosed in parentheses
#193: FILE: arch/x86/entry/vdso/extable.h:11:
+#define _ASM_VDSO_EXTABLE_HANDLE(from, to)	\
+	ASM_VDSO_EXTABLE_HANDLE from to

ERROR: need consistent spacing around '*' (ctx:WxV)
#244: FILE: arch/x86/entry/vdso/vdso2c.h:8:
+static void BITSFUNC(copy)(FILE *outfile, const unsigned char *data, size_t len)
                                 ^

ERROR: need consistent spacing around '*' (ctx:WxV)
#263: FILE: arch/x86/entry/vdso/vdso2c.h:27:
+			      FILE *outfile, ELF(Shdr) *sec, const char *name)

I did fix it now. Thanks.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
