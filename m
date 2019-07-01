Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66926C0650E
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 18:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4370221721
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562004028;
	bh=xpY1EBUzIWK61a9XmKXiInhRfflqLqEF8sLQbS9giOg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=MsRGnEhEuIqOF4bnOkpnuwPfhtfI0rikFo8IBiBgUWCJ/XEQujfM7klA0J5ADNhHc
	 qFpQWjdkyWauW+6BxPvOBzpivL14l+w9kXeH3AMAw8PDLYay7CdhaUE9gqFmOwvDps
	 XJui7yGWMpfNWerd4Xt+tGqge+DdSfY7cZA9q2Hk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfGASA1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 14:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbfGASA1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 14:00:27 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 114C121850
        for <linux-sgx@vger.kernel.org>; Mon,  1 Jul 2019 18:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562004027;
        bh=xpY1EBUzIWK61a9XmKXiInhRfflqLqEF8sLQbS9giOg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KZ8t3c+46LUc2RnsFuurWFH/RtlewRZNtMF7j8HIvuEqHNorxgZxejmMZfY/VGERp
         dG3fQJbgw1nGK0w7zyxUBm2q0Llxtz5EoHmfhb5YUJkNpnxwiPz4cPngO/KAWjE/+z
         FS4rdGPJFxAoXqyi1zV9mguWIhiUxJHl8q/Fm6ug=
Received: by mail-wm1-f51.google.com with SMTP id n9so429352wmi.0
        for <linux-sgx@vger.kernel.org>; Mon, 01 Jul 2019 11:00:26 -0700 (PDT)
X-Gm-Message-State: APjAAAX6DWfiautV1HzskH/4ZE6KSBqD0Nvul/HIlVzQw4w4k68nvy5r
        xbwh7Azz8fem9RzGNdQ2uxYyNQF6CXG3i5xgNXtfpQ==
X-Google-Smtp-Source: APXvYqyw9dvWrtHk90LkZmKRlVzMRqpHgJe9TzwyFIZj43TF8150/NTA+Lgjqy/I6sp4bNqHi6jmJGneIt0FYHs7+TE=
X-Received: by 2002:a1c:1a56:: with SMTP id a83mr303202wma.161.1562004025513;
 Mon, 01 Jul 2019 11:00:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190619222401.14942-1-sean.j.christopherson@intel.com> <20190619222401.14942-5-sean.j.christopherson@intel.com>
In-Reply-To: <20190619222401.14942-5-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 1 Jul 2019 11:00:14 -0700
X-Gmail-Original-Message-ID: <CALCETrXtVzCZW4mb994prdrzXxMP2T=xxU+fhy5k9N8AqjcqhA@mail.gmail.com>
Message-ID: <CALCETrXtVzCZW4mb994prdrzXxMP2T=xxU+fhy5k9N8AqjcqhA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 04/12] x86/sgx: Require userspace to define enclave
 pages' protection bits
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 3:24 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>  static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>         struct sgx_encl *encl = file->private_data;
> +       unsigned long allowed_rwx;
>         int ret;
>
> +       allowed_rwx = sgx_allowed_rwx(encl, vma);
> +       if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC) & ~allowed_rwx)
> +               return -EACCES;
> +
>         ret = sgx_encl_mm_add(encl, vma->vm_mm);
>         if (ret)
>                 return ret;
>
> +       if (!(allowed_rwx & VM_READ))
> +               vma->vm_flags &= ~VM_MAYREAD;
> +       if (!(allowed_rwx & VM_WRITE))
> +               vma->vm_flags &= ~VM_MAYWRITE;
> +       if (!(allowed_rwx & VM_EXEC))
> +               vma->vm_flags &= ~VM_MAYEXEC;
> +

I'm with Cedric here -- this is no good.  The reason I think we need
.may_mprotect or similar is exactly to avoid doing this.

mmap() just needs to make the same type of VMA regardless of the pages
in the range.
