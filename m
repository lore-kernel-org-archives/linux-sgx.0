Return-Path: <SRS0=zuU4=NO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFBAC0044C
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 13:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E7F92082D
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 13:22:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jxi/Qk2v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E7F92082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbeKCWeH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 18:34:07 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:32914 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbeKCWeH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 3 Nov 2018 18:34:07 -0400
Received: by mail-qk1-f194.google.com with SMTP id o89so7606022qko.0;
        Sat, 03 Nov 2018 06:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JzSMpRov2s5eQW704mg4yHFih2u2ihs5fs+BX5Ru0dE=;
        b=Jxi/Qk2vy3iBWqxV0m6A+4uiPQNnUPmH0EY2cPkzYsG+AbQ5upjSkwBssnjg7+2QeD
         043ZTLFfbkMlgR4wNkia5dmCH0wignz5IzM8VOYE/VYKPw5ozinfo+cKWwcwzHjzkrCN
         gVDOKmeklZNTRVD/tQGw+nSnJPXPGvyDgIHKKFpbX97x5cydwxPDyRMiHdUNN8XPdggM
         DAsU25zrNnxVURQcxE1mLnW0nyvkZKvibyCg8h4D9Vzko30JdyAB3UTNypxcPyWjZ4qz
         Lk/hVW73iGozLQ/uOjF1+VaitFjgdmaKP3x+Y+uaRKtb/k4bsI9pYmrIqS1g3VHE+79j
         aPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JzSMpRov2s5eQW704mg4yHFih2u2ihs5fs+BX5Ru0dE=;
        b=Q1s17Ek05mAqjAF3/pXko64DyT8asElOk4f3GehKBuHb6jZgPXQkIeNbWRP2mjMWYW
         9pqKJrNM5BpEoOMHbMcywd5q9leIIoa7Fn76YheM1UCxNiM3Ih0lw6Oy1Gf3L1DPhgyt
         U/HTkl3GQ51ZJRki9flsS8i+xZIFYWAEbnSgE2DfOJjjdgLtVH8VJWSU0q3btWk2/ZuS
         upNHcqKiLzybh70rYi0q96+10nXjtY5DmSwYp5s8N0eJxP99NXQ8zgJgvitl4Wl8AAVp
         RzzR6+KRlPRxZa9EyJwg/tBhWQNOSRDdu+c09Q1Kgdl7+QfmQ8MEOsG+D43AkDPta+H8
         bYrg==
X-Gm-Message-State: AGRZ1gJWmJ+UZW51a9R6qHtVmxN6B5kLXqIjAixJ6EkQo7TLqqsa153J
        jZzAAdPHQuzfm5u5q+jfU0Mv8lyKeUXzXAA3ivk=
X-Google-Smtp-Source: AJdET5deiJQFen6djqRUcB5XN4tJCGV0DcpSzyzy4jFjvWeQAFI5Ne+mKdGzQa2ya5uz+xKJstUR9AJZVYHy+6DkINE=
X-Received: by 2002:a0c:d268:: with SMTP id o37mr14686970qvh.136.1541251366132;
 Sat, 03 Nov 2018 06:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com> <20181102231320.29164-17-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-17-jarkko.sakkinen@linux.intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 3 Nov 2018 15:22:34 +0200
Message-ID:
 <CAHp75Vcq_L5RYSEDcBSd-q09onp6O6_JU1_2MrZ3sAmyX7XgLQ@mail.gmail.com>
Subject: Re: [PATCH v15 16/23] x86/sgx: Enumerate and track EPC sections
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181103132234.4bAxCpWlHjc-QUfjZd_ffJ6Hv9XHZdDTwSR9XjTICWk@z>

On Sat, Nov 3, 2018 at 1:17 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Enumerate Enclave Page Cache (EPC) sections via CPUID and add the data
> structures necessary to track EPC pages so that they can be allocated,
> freed and managed.  As a system may have multiple EPC sections, invoke
> CPUID on SGX sub-leafs until an invalid leaf is encountered.
>
> On NUMA systems, a node can have at most one bank. A bank can be at
> most part of two nodes.  SGX supports both nodes with a single memory
> controller and also sub-cluster nodes with severals memory controllers
> on a single die.
>
> For simplicity, support a maximum of eight EPC sections.  Current
> client hardware supports only a single section, while upcoming server
> hardware will support at most eight sections.  Bounding the number of
> sections also allows the section ID to be embedded along with a page's
> offset in a single unsigned long, enabling easy retrieval of both the
> VA and PA for a given page.

> +       iounmap(section->va);

> +       section->va = ioremap_cache(addr, size);
> +       if (!section->va)
> +               return -ENOMEM;

I forgot if it's a place in code on which we discussed ioremap() vs.
memremap() call.
And I forgot why the conclusion is to leave ioremap().

Sorry, if I'm mistaken.

-- 
With Best Regards,
Andy Shevchenko
