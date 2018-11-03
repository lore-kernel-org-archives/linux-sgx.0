Return-Path: <SRS0=zuU4=NO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229F8C0044C
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 13:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9BA42082E
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 13:11:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BYItpg61"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9BA42082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbeKCWXK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 18:23:10 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37167 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbeKCWXJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 3 Nov 2018 18:23:09 -0400
Received: by mail-qk1-f193.google.com with SMTP id 131so7537454qkd.4;
        Sat, 03 Nov 2018 06:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3dzFCWaGvY5KFjWHvqsJVWBcDuapQeVNu86FFOkK8IA=;
        b=BYItpg61k3VralrqBQ59UKQlUW2o8WxXX1UGYyAF4huIgePXs6JGu+DmYI5NkrM35e
         Z9Bk873KIQiTqJEzZ1UmlscHlgkUTgzlnJFVS9I+z6FfalUA9Ocg7/CVlgzjx4jC/zYv
         Xc7IH5Gj73FHH+SmMerLsRG7bcUEofhfOdI+oZGCrHl/AzFJKM0NnRFMO+p2fJEKpAYK
         13OLo6prRIRI9ld5SZd2cznEjUy+HCGpkA4DQdz+RzIal3wOFSGkmsJSNblcQGCOwDBh
         pfWARxIKfewoTsFJU+i2naJb8946DFe/OT+pfHis3SgMRJz/41UNANpaa5qYAkkWIP/u
         ZWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3dzFCWaGvY5KFjWHvqsJVWBcDuapQeVNu86FFOkK8IA=;
        b=QHHf1o4Yhq7tLRd3PAdqvzJSEFeE6/+Lo+cYVeCwpcG0/N6SNfmUlFNesrzsAod9Aw
         7QgfmnxufUm0p8SGZKLRogt6GD4rMo5bAGQz7T7t3kCBZ1MYYSnBYZDika4yuIbTPvLL
         rBDIp2j+y8LLiG4I6InrtT+kgGWNmzMWD3x/ZMgufOJU5QUGkNeichx0tQt1Wr7rWQaT
         caThF3pfeTyv1ltCKWHUhkOsWi8rFFhXll1s5c18fBj7jJtTVPczpAQcEBYazY49y364
         IyVnlo5fleIWZWI5QmZPreU4/xZYwe3ZIONPyvsmU5bZKTcdBwhxg7Yk0MmSaGDuCJxe
         +AyQ==
X-Gm-Message-State: AGRZ1gIJY1EXMjvlxFY+HFdz9ji9Wg713xTNgRv1LveXH2jG6jsxzaSR
        TN2XJp/4jxCKS8qXEvqAhgs4BDy7+orp3UkjvZI=
X-Google-Smtp-Source: AJdET5eW3vLJ92lXgsYdwWqsk5atGgyN3Go1JBW2Wt4PWXa997DplyiTvpfQrccRAeZ4dX3HuKz5dhWFtTwKvqYtF6s=
X-Received: by 2002:aed:2d24:: with SMTP id h33mr7316208qtd.373.1541250710755;
 Sat, 03 Nov 2018 06:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com> <20181102231320.29164-12-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-12-jarkko.sakkinen@linux.intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 3 Nov 2018 15:11:39 +0200
Message-ID:
 <CAHp75VcgFstv5EjY2DzsLGAimxf3Z2g-Mych1zW40txS9b7Bmg@mail.gmail.com>
Subject: Re: [PATCH v15 11/23] x86/sgx: Add definitions for SGX's CPUID leaf
 and variable sub-leafs
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181103131139.HVNV5tfGSjlLdHH9HZIGFz4DZHdlf7dK5wmQfdGV8DM@z>

On Sat, Nov 3, 2018 at 1:16 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> SGX defines its own CPUID leaf, 0x12, along with a variable number of
> sub-leafs.  Sub-leafs 0 and 1 are always available if SGX is supported
> and enumerate various SGX features, e.g. instruction sets and enclave
> capabilities.  Sub-leafs 2+ are variable, both in their existence and
> in what they enumerate.  Bits 3:0 of EAX report the sub-leaf type,
> with the remaining bits in EAX, EBX, ECX and EDX being type-specific.
> Currently, the only known sub-leaf type enumerates an EPC section.  An
> EPC section is simply a range of EPC memory available to software.
> The "list" of varaible SGX sub-leafs is NULL-terminated, i.e. software
> is expected to query CPUID until an invalid sub-leaf is encountered.

> +       SGX_CPUID_SUB_LEAF_TYPE_MASK    = 0xF,

GENMASK() if it suits here?

P.S. Btw, BIT() and GENMASK() macros are now in a separate header,
i.e. linux/bits.h, perhaps you might need to revisit code to include
it explicitly

--
With Best Regards,
Andy Shevchenko
