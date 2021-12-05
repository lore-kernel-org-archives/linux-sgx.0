Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD585C433FE
	for <linux-sgx@archiver.kernel.org>; Sun,  5 Dec 2021 13:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhLENNW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 5 Dec 2021 08:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbhLENNU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 5 Dec 2021 08:13:20 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8B9C061714
        for <linux-sgx@vger.kernel.org>; Sun,  5 Dec 2021 05:09:53 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id p4so8581180qkm.7
        for <linux-sgx@vger.kernel.org>; Sun, 05 Dec 2021 05:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dtYLmGkWKn/52i7M34wleyxhHkWbT48Sy+Al0iZ03oc=;
        b=ivK1yal+SGyqtPza6xtmc5lzZD6dWBPHRUDMwpd/32MM4KF9MHNwFnt0JHwkkSnV4k
         3ooaOV0ZKmJASBpBQJk8OQJhs8uWRmEF4o626hepSEK8KTOfo8tvl8jpYdp/tsZul+V2
         T0oI2byzSBbZQEp6FSlYzUt0PaDUEGp5y8jCzmwTUyfFaTuXGvTXH/ilVDkShXzt4alF
         jyoXuz1TI6m4TtfTozljqzqQKcWuNWKOnu141vTzWvVyuM6WC6XrZsMt/DVQBAnVoBqi
         mU6oSI3i/2/5sM4o7PsGDLt+qo5BP1kW0SqeRtXbQsPpmNGsd3KQgi+SUltwW/rEpPfh
         HlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dtYLmGkWKn/52i7M34wleyxhHkWbT48Sy+Al0iZ03oc=;
        b=i0fhXFxHIEWW4m+ajv7ak4s5JF/vGTF2+CURYteZh3eiQDgZ5o3GtJhQING5TZvEBJ
         aEciKKILLRMkOsJkY/oLpyEWpQiERucamfyl2gAuCUTFk2pA80zY49ihjVcDIq92KbBp
         TNTzsluMHXSf6pPljtivFdK+Hvpg2McamuIfPv6zi9KiHc2A7jlksqignieWTKPYAbFM
         VgcP7bjvWYay0g5zcEpMz5d3oDEzhk1gH9/AOcvTpsSmjbh46lfCdsqvSgwBokETCVz6
         a8JPKA9ixzQKj9hWRanj31+1R+zOFJQ+WbkPOUk6OXvqFvhxzozxmRNFCftzNpqrIDix
         VE2w==
X-Gm-Message-State: AOAM532/Ogve1s0lH8dLlJPMTSDjDDYQy+d+LGm0vAXiJ4wcFuLnmSiB
        ot+Xauw5ytClbGXln2ij2UWO8ALMXtMTtBqR0hzPMGsQ9KE=
X-Google-Smtp-Source: ABdhPJzhYfQwgozo4biSXamjnn2Y7Hy+ujKNaOb9xjlT22IIoPobuoG8HYCpGFAw1W5PtX4RxcJKuCJExxvvA6mCrmY=
X-Received: by 2002:a37:984:: with SMTP id 126mr27654516qkj.257.1638709792209;
 Sun, 05 Dec 2021 05:09:52 -0800 (PST)
MIME-Version: 1.0
References: <CAHAy0tS9PXgb4cRFEZNEYpiwPVV3CpBRFQhbFN=+XXy=MQakRg@mail.gmail.com>
 <YavT0+e/GoK8gsKu@iki.fi>
In-Reply-To: <YavT0+e/GoK8gsKu@iki.fi>
From:   Nathaniel McCallum <nathaniel@profian.com>
Date:   Sun, 5 Dec 2021 08:09:41 -0500
Message-ID: <CAHAy0tS7Xons5b7dVMEdhrzAhcUL0zKfiGy7OpTD9SrppQcYVA@mail.gmail.com>
Subject: Re: Possible Regression: 5.14.18 => 5.15.6
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

That was it! We had switched to debian for our work on SGX2 and they
use noexec. Thanks!

On Sat, Dec 4, 2021 at 3:47 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
>
> On Sat, Dec 04, 2021 at 08:54:08AM -0500, Nathaniel McCallum wrote:
> > We are seeing a possible regression between 5.14.18 and 5.15.6. Our
> > trace logging shows the following output:
> >
> > enclave location: 00007f3c00000000-00007f3c80000000
> > creating enclave: Secs { size: 2147483648, baseaddr: 139895674765312,
> > ssaframesize: 1, miscselect: (empty), attributes: Attributes {
> > features: MODE64BIT, xfrm: X87 | SSE }, pid: 0, svn: 0 }
> > adding pages: 00007f3c00000000-00007f3c00004000 R
> > adding pages: 00007f3c00004000-00007f3c0000c000 RW
> > adding pages: 00007f3c0000c000-00007f3c00039000 RX
> > adding pages: 00007f3c00201000-00007f3c003fc000 RW
> > adding pages: 00007f3c003fc000-00007f3c003fd000 T
> > adding pages: 00007f3c003fd000-00007f3c00400000 RW
> > adding pages: 00007f3c00400000-00007f3c00401000 R
> > adding pages: 00007f3c00401000-00007f3c00402000 RX
> > adding pages: 00007f3c00402000-00007f3c00403000 R
> > adding pages: 00007f3c00403000-00007f3c00404000 RW
> > enclave initialized
> > remapping: 00007f3c00000000-00007f3c00004000 R
> > remapping: 00007f3c00004000-00007f3c0000c000 RW
> > remapping: 00007f3c0000c000-00007f3c00039000 RX
> > Error: Operation not permitted (os error 1)
> >
> > Using strace shows this:
> > ...
> > mmap(0x7f6e80000000, 16384, PROT_READ, MAP_SHARED|MAP_FIXED, 3, 0) =
> > 0x7f6e80000000
> > mmap(0x7f6e80004000, 32768, PROT_READ|PROT_WRITE,
> > MAP_SHARED|MAP_FIXED, 3, 0) = 0x7f6e80004000
> > mmap(0x7f6e8000c000, 184320, PROT_READ|PROT_EXEC,
> > MAP_SHARED|MAP_FIXED, 3, 0) = -1 EPERM (Operation not permitted)
> >
> > We've followed the selftest structure pretty closely. The first two
> > remapping calls succeed, but the third one fails. This works on
> > 5.14.18, but fails on 5.15.6.
>
> What are the mount options of /dev?
>
> /Jarkko
