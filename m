Return-Path: <SRS0=smjw=OA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC85C43441
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Nov 2018 18:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3687D214D9
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Nov 2018 18:17:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="iV9aqA7A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3687D214D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733066AbeKVExC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Nov 2018 23:53:02 -0500
Received: from mail.skyhub.de ([5.9.137.197]:53656 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729486AbeKVExC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Nov 2018 23:53:02 -0500
Received: from zn.tnic (p200300EC2BD0AB00883B4D3E2A7F8FA4.dip0.t-ipconnect.de [IPv6:2003:ec:2bd0:ab00:883b:4d3e:2a7f:8fa4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9E6531EC04DA;
        Wed, 21 Nov 2018 19:17:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1542824255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uBn5Lp/NIAUXZ/IbISzpsZb7P5e1DZUQOmxj+auHdXk=;
        b=iV9aqA7A55c/xr49Re2FdryjpJ4T6pMkDN9p23GgVMhVb15ei1AKrkJsl6sBp34jYtR24x
        dB216zAxIDP+Jbwblp/hG6ce+EZO5xHB+3aAOm9WM8GHcVthjHOfbm2dyNcRwsQnoYdWKt
        aKNGBIyi+YK488Jpi1BrEf6q0aPQba8=
Date:   Wed, 21 Nov 2018 19:17:28 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        David Wang <davidwang@zhaoxin.com>,
        "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>,
        Jia Zhang <qianyue.zj@alibaba-inc.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 06/23] x86/cpu/intel: Detect SGX support and update
 caps appropriately
Message-ID: <20181121181728.GA27559@zn.tnic>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-7-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181116010412.23967-7-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 16, 2018 at 03:01:13AM +0200, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Similar to other large Intel features such as VMX and TXT, SGX must be
> explicitly enabled in IA32_FEATURE_CONTROL MSR to be truly usable.
> Clear all SGX related capabilities if SGX is not fully enabled in
> IA32_FEATURE_CONTROL or if the SGX1 instruction set isn't supported
> (impossible on bare metal, theoretically possible in a VM if the VMM is
> doing something weird).
> 
> Like SGX itself, SGX Launch Control must be explicitly enabled via a
> flag in IA32_FEATURE_CONTROL. Clear the SGX_LC capability if Launch
> Control is not fully enabled (or obviously if SGX itself is disabled).
> 
> Note that clearing X86_FEATURE_SGX_LC creates a bit of a conundrum
> regarding the SGXLEPUBKEYHASH MSRs, as it may be desirable to read the
> MSRs even if they are not writable, e.g. to query the configured key,
> but clearing the capability leaves no breadcrum for discerning whether
> or not the MSRs exist.  But, such usage will be rare (KVM is the only
> known case at this time) and not performance critical, so it's not
> unreasonable to require the use of rdmsr_safe().  Clearing the cap bit
> eliminates the need for an additional flag to track whether or not
> Launch Control is truly enabled, which is what we care about the vast
> majority of the time.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/intel.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index fc3c07fe7df5..8a20a193d399 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -596,6 +596,40 @@ static void detect_tme(struct cpuinfo_x86 *c)
>  	c->x86_phys_bits -= keyid_bits;
>  }
>  
> +static void detect_sgx(struct cpuinfo_x86 *c)
> +{
> +	unsigned long long fc;
> +
> +	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
> +	if (!(fc & FEATURE_CONTROL_LOCKED)) {
> +		pr_err_once("sgx: IA32_FEATURE_CONTROL MSR is not locked\n");
> +		goto out_unsupported;
> +	}
> +
> +	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
> +		pr_err_once("sgx: not enabled in IA32_FEATURE_CONTROL MSR\n");

Start those messages with a capital letter: "sgx: SGX is not enabled ...".

> +		goto out_unsupported;
> +	}
> +
> +	if (!cpu_has(c, X86_FEATURE_SGX1)) {
> +		pr_err_once("sgx: SGX1 instruction set not supported\n");
> +		goto out_unsupported;
> +	}
> +
> +	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {

I see the build failure here has been pointed out already but lemme
repeat it out for another reason:

It is very important that no patch we merge breaks bisectability -
please build every patch before sending:

arch/x86/kernel/cpu/intel.c: In function ‘detect_sgx’:
arch/x86/kernel/cpu/intel.c:619:13: error: ‘FEATURE_CONTROL_SGX_LE_WR’ undeclared (first use in this function); did you mean ‘FEATURE_CONTROL_SGX_ENABLE’?
  if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
             ^~~~~~~~~~~~~~~~~~~~~~~~~
             FEATURE_CONTROL_SGX_ENABLE
arch/x86/kernel/cpu/intel.c:619:13: note: each undeclared identifier is reported only once for each function it appears in
make[3]: *** [scripts/Makefile.build:291: arch/x86/kernel/cpu/intel.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:516: arch/x86/kernel/cpu] Error 2
make[1]: *** [scripts/Makefile.build:516: arch/x86/kernel] Error 2
make: *** [Makefile:1060: arch/x86] Error 2
make: *** Waiting for unfinished jobs....


> +		pr_info_once("sgx: launch control MSRs are not writable\n");
> +		goto out_msrs_rdonly;
> +	}
> +
> +	return;

<---- newline here.

> +out_unsupported:
> +	setup_clear_cpu_cap(X86_FEATURE_SGX);
> +	setup_clear_cpu_cap(X86_FEATURE_SGX1);
> +	setup_clear_cpu_cap(X86_FEATURE_SGX2);

<---- newline here.

> +out_msrs_rdonly:
> +	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> +}

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
