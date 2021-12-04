Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E458BC433EF
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Dec 2021 20:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352275AbhLDUur (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 4 Dec 2021 15:50:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35246 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbhLDUur (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 4 Dec 2021 15:50:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9397B80D6A
        for <linux-sgx@vger.kernel.org>; Sat,  4 Dec 2021 20:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C42C341C0;
        Sat,  4 Dec 2021 20:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638650838;
        bh=HD7ianve5pdIRZvBfK1Q8TBKVyB8D0r45ujHuB+wBNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FmgONtp6V37Gzf9act25NJbG/o4ElRNhrPl1/L9uzqU0nrYE1qb/Djt79GIfqagSC
         tic8w8CN5oEDHENUCc5uWzraP33uO8inoJALQ9Cz8Uew9rqyXcQHSWIazRkQj507no
         kt9NHtkUyUI0vI6FdS9cVxIvO/B48T0XQOoqZX2m9PplzFrdRvjO4aV3SzWKOD89Cj
         7CiYHTdR+O1+401Ty6+N85/H18IMgMJmOh9axhAagAW5iC7ceOdvcCa5b5PxEspW0P
         aPYbpSiNLqhIdK126hUlv6upNWX7LdUxafkU8DERvz1Zgz1YHUMDzuuiqZrmNlDsm5
         9R8c0zJcLB7Aw==
Date:   Sat, 4 Dec 2021 22:47:15 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Nathaniel McCallum <nathaniel@profian.com>
Cc:     linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: Possible Regression: 5.14.18 => 5.15.6
Message-ID: <YavT0+e/GoK8gsKu@iki.fi>
References: <CAHAy0tS9PXgb4cRFEZNEYpiwPVV3CpBRFQhbFN=+XXy=MQakRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHAy0tS9PXgb4cRFEZNEYpiwPVV3CpBRFQhbFN=+XXy=MQakRg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Dec 04, 2021 at 08:54:08AM -0500, Nathaniel McCallum wrote:
> We are seeing a possible regression between 5.14.18 and 5.15.6. Our
> trace logging shows the following output:
> 
> enclave location: 00007f3c00000000-00007f3c80000000
> creating enclave: Secs { size: 2147483648, baseaddr: 139895674765312,
> ssaframesize: 1, miscselect: (empty), attributes: Attributes {
> features: MODE64BIT, xfrm: X87 | SSE }, pid: 0, svn: 0 }
> adding pages: 00007f3c00000000-00007f3c00004000 R
> adding pages: 00007f3c00004000-00007f3c0000c000 RW
> adding pages: 00007f3c0000c000-00007f3c00039000 RX
> adding pages: 00007f3c00201000-00007f3c003fc000 RW
> adding pages: 00007f3c003fc000-00007f3c003fd000 T
> adding pages: 00007f3c003fd000-00007f3c00400000 RW
> adding pages: 00007f3c00400000-00007f3c00401000 R
> adding pages: 00007f3c00401000-00007f3c00402000 RX
> adding pages: 00007f3c00402000-00007f3c00403000 R
> adding pages: 00007f3c00403000-00007f3c00404000 RW
> enclave initialized
> remapping: 00007f3c00000000-00007f3c00004000 R
> remapping: 00007f3c00004000-00007f3c0000c000 RW
> remapping: 00007f3c0000c000-00007f3c00039000 RX
> Error: Operation not permitted (os error 1)
> 
> Using strace shows this:
> ...
> mmap(0x7f6e80000000, 16384, PROT_READ, MAP_SHARED|MAP_FIXED, 3, 0) =
> 0x7f6e80000000
> mmap(0x7f6e80004000, 32768, PROT_READ|PROT_WRITE,
> MAP_SHARED|MAP_FIXED, 3, 0) = 0x7f6e80004000
> mmap(0x7f6e8000c000, 184320, PROT_READ|PROT_EXEC,
> MAP_SHARED|MAP_FIXED, 3, 0) = -1 EPERM (Operation not permitted)
> 
> We've followed the selftest structure pretty closely. The first two
> remapping calls succeed, but the third one fails. This works on
> 5.14.18, but fails on 5.15.6.

What are the mount options of /dev?

/Jarkko
