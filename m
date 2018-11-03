Return-Path: <SRS0=zuU4=NO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910ABC0044C
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 13:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 464922082E
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 13:15:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vCO2twoH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 464922082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbeKCW0r (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 18:26:47 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33701 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbeKCW0r (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 3 Nov 2018 18:26:47 -0400
Received: by mail-qk1-f195.google.com with SMTP id o89so7585552qko.0;
        Sat, 03 Nov 2018 06:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dTSd7ETL/2YZCStrIYOT7JHFdH59w9vpDKocxhwuc4U=;
        b=vCO2twoHmnVgZhTtVLSwkmF60UUy/TqC8I4HnKKdJykPVTTXsk2mZxomITzxIeuFcN
         v144RPKMV0qSLYJ4umAgixIWJSzw5h/wfLiFDPs+t6NBEO8OZDAZIp/xeYn+dPfDBWee
         2Wh0Im59hzt5GCdKUEaq7Jyt8lX5jYOOuAKlvV21JrZ8X8wnTL8EeS3paR1U4l6C2lbw
         HiAIYZ/VmewTJAFVXe3aXHQCiPLKWrTJNA20c0Fk+1JViPcOyNEFCWZZk7Typ/qH/YVu
         hzXIw5DmuPSHvZZz6dO2UzvocEEs722wcQfS9cxvbQQJAdQRpfb5ZPDZku87gM8uPK3g
         nEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dTSd7ETL/2YZCStrIYOT7JHFdH59w9vpDKocxhwuc4U=;
        b=H3rcCTdq+FnB78M/g9sgPq1+0X1RU8p62mU3tpBBdsjICWHuIkGRR2OHeu7dWPYNbH
         J7FY7Mp7IRlX5C8Q1mUC+AKTfZl/CSm+HCNqIQmHkCKfYL+7MtxtklzBD7GQuZtFJZq2
         JdYkSuHrPLq20Is2r/HvViiy+HDBdcuDsV6cqxhCUO0q+aNXrktYdxkOC2u6cU/+as3n
         j3BFn03m6yvlsVBOqbsfpsZkplhZmy5elfw0kIcWiy6dinyNQ4YQy1PCLKnm+yOklOpC
         BPwAH1W6ACWNPOdbZqkJVsJbfWNoaiZ3ebH5Lm/F8VUBjwYbrQk5UV5zTtIx/BJsh9cU
         jP7g==
X-Gm-Message-State: AGRZ1gJPT9+EWyXmnnld1wtmTdUoCRTuonfFU+IpGvQntEVZB9gIAglr
        1kE6tsBnQ5kMbuygMY8fuVEXdvVMUP6wBravJTs=
X-Google-Smtp-Source: AJdET5ffurUkjxe9wJY4bkOsqu8V2D/rzPT6rCJpnxh2+IVLMu0RI7aygtjk+YG2Dmm0OVrOXC7+7zkwyzszrnNgtYo=
X-Received: by 2002:ac8:684:: with SMTP id f4-v6mr4315514qth.194.1541250927218;
 Sat, 03 Nov 2018 06:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com> <20181102231320.29164-15-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-15-jarkko.sakkinen@linux.intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 3 Nov 2018 15:15:15 +0200
Message-ID:
 <CAHp75VctUJRTecG4rVHXm0uO18ZndMgqJgtNyG25HtSzJF5uzg@mail.gmail.com>
Subject: Re: [PATCH v15 14/23] x86/cpu/intel: Clear SGX_LC capability if not
 enabled in FEATURE_CONTROL
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
        David Woodhouse <dwmw@amazon.co.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        davidwang@zhaoxin.com,
        "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>,
        qianyue.zj@alibaba-inc.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181103131515.uzuMG-Sd4sg-ns2nYRk5BViGIsZjBKeUlQQfjGiXv_I@z>

On Sat, Nov 3, 2018 at 1:17 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Like SGX itself, SGX Launch Control must be explicitly enabled via a
> flag in IA32_FEATURE_CONTROL.  Clear the SGX_LC capability if Launch
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

> @@ -618,6 +618,8 @@ static void detect_sgx(struct cpuinfo_x86 *c)
>                 setup_clear_cpu_cap(X86_FEATURE_SGX1);
>                 setup_clear_cpu_cap(X86_FEATURE_SGX2);
>         }
> +       if (unsupported || !(fc & FEATURE_CONTROL_SGX_LE_WR))
> +               setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
>  }

A-ha, I see how you use this variable here (though it's still possible
to get rid of it, choose what is better for readability /
maintenance).

-- 
With Best Regards,
Andy Shevchenko
