Return-Path: <SRS0=KcaY=XU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07678C432C1
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 08:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB62821D7E
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 08:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="BniSd+ZF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390395AbfIYIwP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Sep 2019 04:52:15 -0400
Received: from mail.skyhub.de ([5.9.137.197]:37796 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbfIYIwF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Sep 2019 04:52:05 -0400
Received: from zn.tnic (p200300EC2F0BA1006CC827149FB87000.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:a100:6cc8:2714:9fb8:7000])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7FCC61EC0626;
        Wed, 25 Sep 2019 10:51:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569401515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PYw2Mz8W8OtmzlEEkLHK/sC9YLg0cHI0jU0rRt8Jd4M=;
        b=BniSd+ZF1kYem2vLfKYcA12PH1ziv3RjcwVNDvTeF0w91b4PlEH5NZIQBnBBM+pMs+TY3k
        FquWMf8tQq8+yui6KGzieFi1Pm1QUuI126ZP89Mgpj5DPOTnY8dKMdbiGmbKtaqxhHdr66
        BTBEZZWfocr9cCSUSYsmQ/D2EFz1B5g=
Date:   Wed, 25 Sep 2019 10:51:56 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, Kai Huang <kai.huang@linux.intel.com>,
        Haim Cohen <haim.cohen@intel.com>
Subject: Re: [PATCH v22 02/24] x86/cpufeatures: x86/msr: Intel SGX Launch
 Control hardware bits
Message-ID: <20190925085156.GA3891@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
 <20190924155232.GG19317@zn.tnic>
 <20190924202210.GC16218@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190924202210.GC16218@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 24, 2019 at 01:22:10PM -0700, Sean Christopherson wrote:
> The approach we chose (patch 04, which we were discussing) is to disable
> SGX if SGX_LE_WR is not set, i.e. disallow SGX unless the hash MSRs exist
> and are fully writable.

Hmm, so I see

+       if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
+               pr_info_once("sgx: The launch control MSRs are not writable\n");
+               goto err_msrs_rdonly;

which clears only X86_FEATURE_SGX_LC but leaves the other three feature
bits set?!

If you'd want to disable SGX then you'd need to jump to the
err_unsupported label and get rid of the err_msrs_rdonly one.

Or am I missing something?

> WRMSR will #GP if FEATURE_CONTROL is locked (bit 0), e.g. attempting to
> set SGX_LE_WR will trap if FEATURE_CONTROL was locked by BIOS.

Right.

> And conversely, the various enable bits in FEATURE_CONTROL don't
> take effect until FEATURE_CONTROL is locked, e.g. the LE hash MSRs
> aren't writable if FEATURE_CONTROL is unlocked, regardless of whether
> SGX_LE_WR is set.

Ok. We want them writable.

> Sadly, because FEATURE_CONTROL must be locked to fully enable SGX, the
> reality is that any BIOS that supports SGX will lock FEATURE_CONTROL.

That's fine. The question is, would OEMs leave the hash MSRs writable?

If, as you say above, we clear SGX feature bit - not only
X86_FEATURE_SGX_LC - when the MSRs are not writable, then we're fine.
Platforms sticking their own hash in there won't be supported but I
guess their aim is not to be supported in Linux anyway.

> That's the status quo today as well since VMX (and SMX/TXT) is also
> enabled via FEATURE_CONTROL.  KVM does have logic to enable VMX and lock
> FEATURE_CONTROL if the MSR isn't locked, but AIUI that exists only to work
> with old BIOSes.
> 
> If we want to support setting and locking FEATURE_CONTROL in the extremely
> unlikely scenario that BIOS left it unlocked, the proper change would be

I wouldn't be too surprised if this happened. BIOS is very inventive.

> One note on Launch Control that isn't covered in the SDM: the LE hash
> MSRs can also be written before SGX is activated.  SGX activation must
> occur before FEATURE_CONTROL is locked, meaning BIOS can set the LE
> hash MSRs to a non-intel and then lock FEATURE_CONTROL with SGX_LE_WR=0.

This is exactly what I'm afraid of. The OEM vendors locking this down.

> Heh, why stop at 4?  12_EBX, 12_1_ECX and 12_1_EDX are effectively feature
> leafs as well, although the kernel can ignore them for the most part.

Yeah, we're mentally prepared for the feature bit space explosion. :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
