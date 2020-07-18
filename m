Return-Path: <SRS0=GdqB=A5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8B1C433E1
	for <linux-sgx@archiver.kernel.org>; Sat, 18 Jul 2020 20:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDE3220775
	for <linux-sgx@archiver.kernel.org>; Sat, 18 Jul 2020 20:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.b="IwWw+pOP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGRUSN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 18 Jul 2020 16:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgGRUSK (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 18 Jul 2020 16:18:10 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D9FC0619D4
        for <linux-sgx@vger.kernel.org>; Sat, 18 Jul 2020 13:18:10 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id w34so10265654qte.1
        for <linux-sgx@vger.kernel.org>; Sat, 18 Jul 2020 13:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Wzy+cAnfVWyCNBRsbp4f96uaFuyezcnGy3p//wWBWlc=;
        b=IwWw+pOP8iz9mglvw1oqstQ6ZxJyWkhps+nXR1W7C87271q704wKNliO3g40NlXtYX
         FEdEP8H3UzLAiUjh7/U6V57lgeSPBgXJlgqoWmm5bZcj13guYXTbt1Ozrp2kuxt/U43T
         SvA7YfgeZqrhMZDtgktMzQKvnW0QuTblDl0Qg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wzy+cAnfVWyCNBRsbp4f96uaFuyezcnGy3p//wWBWlc=;
        b=r6DMr5uWOdMiVvrjgQUNhezu41tSp3fw7LWtAFhw9bRr44pmfo656qE/iUyg517l3x
         5uhedQaZbMDIW9jFcO2BB53RPgoTA+0KWgN9nHiswVqN7G0LUkbMMHgk5wCNrY8qolYc
         Glf7wGD45e6/OI2fybSguNDRfWB+EGnMuWGEGC0QRK3qJ/ZbPB3F7KA1MpivT9w4iSPq
         ipgsjY/81UhB0FwyrFnfnO2ZiCnRO7yiFPI5WXLTCky5GRdoe05BlpUf71v+R78vy0ER
         UJ5tUxE9u8V0O16W1btcwVu+tcVTjyJbVC6bm5D0hgHITu4DqXB0fGVxY0LRg0etQJ5J
         zORg==
X-Gm-Message-State: AOAM531aMLDEOBWIwpwzCfIBe7qyz9A9wLolu/VTUsy996sVsuJj9gsq
        uJ/kKH1l9I2Zemda7Pu+2SJzGx5OzXHnxRDBVkqHDCRnkO3JGDUPVCL+jHtd2v9xtDBtKu7BMy3
        RixLMfPPfEfF+CnWzzpyaHHVZ1m25laHCwPJrBM752DZZxktit8mN70LOwUo+SGPmLA==
X-Google-Smtp-Source: ABdhPJyssU1ufVTgBHVnmx0gim5lL4wHfPYijT9LtU6LhysR/mZAHBckC38fdgAQFzGckorO1LGo+g==
X-Received: by 2002:aed:2723:: with SMTP id n32mr16929892qtd.109.1595103488923;
        Sat, 18 Jul 2020 13:18:08 -0700 (PDT)
Received: from pepe.local (71-142-124-255.lightspeed.rlghnc.sbcglobal.net. [71.142.124.255])
        by smtp.gmail.com with ESMTPSA id p36sm15125718qte.90.2020.07.18.13.18.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 13:18:08 -0700 (PDT)
Subject: Re: Linux FSGSBASE testing
To:     Andy Lutomirski <luto@amacapital.net>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Stas Sergeev <stsp@list.ru>, linux-sgx@vger.kernel.org
References: <CALCETrU_O4AxcJeBO77uXt2j8woYVtjZd18-YV0BuCKRAu00eA@mail.gmail.com>
From:   Don Porter <porter@cs.unc.edu>
Message-ID: <6e3d25fc-9a67-8655-a00a-b3afbc360ff0@cs.unc.edu>
Date:   Sat, 18 Jul 2020 16:18:06 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALCETrU_O4AxcJeBO77uXt2j8woYVtjZd18-YV0BuCKRAu00eA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/20/20 11:59 AM, Andy Lutomirski wrote:
> Hi Stas-
> 
> FSGSBASE support is queued up for Linux 5.9.  Since you're one of the
> more exotic users of segmentation on Linux, is there any chance you
> could test it?  The code is here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/log/?h=x86/fsgsbase
> 
> There are two interesting cases to test:
> 
> 1. FSGSBASE on.  This is the default if you boot this kernel on Ivy
> Bridge or newer hardware.
> 
> 2. FSGSBASE off on a patched kernel.  Boot the same kernel as in #1
> but either pass nofsgsbase on the kernel command line or use pre-Ivy
> Bridge hardware.  You will *
> 
> You can tell you have FSGSBASE enabled for test #1 by running
> tools/testing/selftests/x86/fsgsbase_64 -- the first line of output
> will be :FSGSBASE instructions are enabled".  You can build it by
> cd-ing to tools/testing/selftests/x86 and running make.
> 
> If anything is broken for you, I'd like to know before this makes it
> into a released kernel!
> 
> Thanks,
> Andy
> 

FWIW, we tested this patch using Graphene under Case 1, both in our 
standard CI pipelines, and with hand testing.  Everything looks good on 
our end - no suspicious dmesg, no application-level issues.

I also reran the stress test Andy suggested on a separate thread, which 
also looks good:
* Graphene running nginx pinned to core 0
* infinite loop on core 0
* perf top running
* Exercised with non-SGX apache bench several times (~10 minutes of 
testing time) also from core 0

All the best,
Don
