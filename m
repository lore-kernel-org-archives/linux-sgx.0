Return-Path: <SRS0=zuU4=NO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBD9C0044C
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 13:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 732142081D
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 13:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nhR9GdnF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 732142081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbeKCWRI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 18:17:08 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43366 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbeKCWRI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 3 Nov 2018 18:17:08 -0400
Received: by mail-qk1-f196.google.com with SMTP id r71so7468122qkr.10;
        Sat, 03 Nov 2018 06:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aB4G3w4rpmdu6ojkMiW7GyduUFi8xbFWz6k4BN3jvjQ=;
        b=nhR9GdnF/UdVgznjZyCToBxldtIL8n7A9Y6o0KZ9KKiS6eVqbfSnTUUGpVE3wHar94
         u/fwrxNPl6nTk/0FpADSp8LcYtvfD/hrp2jra85Uh19hiYsJNZk7A7emhT6OHb93IV9I
         vpDf7iuFwPUUFj2aWjcLQsTAidZfvi34StCkIpzQ+QqR2LlLG2KBM0ZWcya4MRIjXR0t
         CfovdKj9isD3FYYxzc9F3AsY4x1Z1VdpYToiuUCA/BTCP6WwYPixvNfpGYEiMkstGTq2
         oCUsKyrTP/FggPDlsAh1Hj9S57TkQ2yr4lFgioQY/SE7QizMvNPyGDakxXYEHHU7VYHr
         GJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aB4G3w4rpmdu6ojkMiW7GyduUFi8xbFWz6k4BN3jvjQ=;
        b=rfSmnsi9eQ7It4DikKGR756vf6PjZ1/Qjdre4ZFHRVE6VvJX/INo2btnLgVSEVNQB4
         d5eEKuv+o6jltXG13BW+9HonMycEr85+4ZukDCKFfXZQfviU9rIZnh1R6aeoDMEM9WVq
         Du3MPK07Cj/Pa763DHMf4L2I+oW1N9+OBWGP0HJY1OtmYbqYuQqo74JERPnIM0/lYMFr
         6x52eglhuHJT+OCHYJN121UWsfVQUkglKHfgt9ZEAlVrHADU+MYge+uZCelh3kT18+q0
         vJhSjkeg72vPDrnFYz252RXr1O4zaA5gOaO0HmzblDTrdV1dZuHvJiiJQIKiLSLGBPgO
         yqTw==
X-Gm-Message-State: AGRZ1gKwfXBP8ASFgs/iPwWSX4SKluhvH6CiSJBX1ePthkmkqcRO8lwq
        vBtXOVQPH5nRG+uHqh0OZNE8HVTu0tt/kb6Tp08=
X-Google-Smtp-Source: AJdET5dOYpTNYGNSVJwS6wRs2D30dtOolmSmPXwn7W2amfMSv2dodxm6VjGm/CyZ5LvsM8Paj8kx7F+ZUFI/lI+0H2k=
X-Received: by 2002:a37:7983:: with SMTP id u125-v6mr13236258qkc.219.1541250350399;
 Sat, 03 Nov 2018 06:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com> <20181102231320.29164-6-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-6-jarkko.sakkinen@linux.intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 3 Nov 2018 15:05:39 +0200
Message-ID:
 <CAHp75VcG4FtiS9bDM_pP216kxobFxkChDu6uxvuTsMHQ=YJ3Zg@mail.gmail.com>
Subject: Re: [PATCH v15 05/23] x86/cpu/intel: Detect SGX support and update
 caps appropriately
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>, davidwang@zhaoxin.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>,
        qianyue.zj@alibaba-inc.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181103130539.K_SDeVCR3Q_aSr-sPThSP_3KcTHRCpF-FSOefF8tGbk@z>

On Sat, Nov 3, 2018 at 1:16 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Similar to other large Intel features such as VMX and TXT, SGX must be
> explicitly enabled in IA32_FEATURE_CONTROL MSR to be truly usable.
> Clear all SGX related capabilities if SGX is not fully enabled in
> IA32_FEATURE_CONTROL or if the SGX1 instruction set isn't supported
> (impossible on bare metal, theoretically possible in a VM if the VMM
> is doing something weird).
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/intel.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index fc3c07fe7df5..9bf8fe2c04ac 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -596,6 +596,30 @@ static void detect_tme(struct cpuinfo_x86 *c)
>         c->x86_phys_bits -= keyid_bits;
>  }
>
> +static void detect_sgx(struct cpuinfo_x86 *c)
> +{
> +       bool unsupported = false;
> +       unsigned long long fc;
> +
> +       rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
> +       if (!(fc & FEATURE_CONTROL_LOCKED)) {
> +               pr_err_once("sgx: IA32_FEATURE_CONTROL MSR is not locked\n");
> +               unsupported = true;
> +       } else if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
> +               pr_err_once("sgx: not enabled in IA32_FEATURE_CONTROL MSR\n");
> +               unsupported = true;
> +       } else if (!cpu_has(c, X86_FEATURE_SGX1)) {
> +               pr_err_once("sgx: SGX1 instruction set not supported\n");
> +               unsupported = true;
> +       }

If you do

} else {
 /* Supported */
 return;
}

here, you may get rid of temporary variable.

(Up to you)

> +
> +       if (unsupported) {
> +               setup_clear_cpu_cap(X86_FEATURE_SGX);
> +               setup_clear_cpu_cap(X86_FEATURE_SGX1);
> +               setup_clear_cpu_cap(X86_FEATURE_SGX2);
> +       }
> +}
> +
>  static void init_intel_energy_perf(struct cpuinfo_x86 *c)
>  {
>         u64 epb;
> @@ -763,6 +787,9 @@ static void init_intel(struct cpuinfo_x86 *c)
>         if (cpu_has(c, X86_FEATURE_TME))
>                 detect_tme(c);
>
> +       if (cpu_has(c, X86_FEATURE_SGX))
> +               detect_sgx(c);
> +
>         init_intel_energy_perf(c);
>
>         init_intel_misc_features(c);
> --
> 2.19.1
>


-- 
With Best Regards,
Andy Shevchenko
