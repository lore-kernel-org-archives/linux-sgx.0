Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B94C4321E
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Dec 2021 13:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhLDN5q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 4 Dec 2021 08:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbhLDN5p (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 4 Dec 2021 08:57:45 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FB6C0613F8
        for <linux-sgx@vger.kernel.org>; Sat,  4 Dec 2021 05:54:20 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id m25so6303932qtq.13
        for <linux-sgx@vger.kernel.org>; Sat, 04 Dec 2021 05:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=rpP/s7RO4bOALLBaZXMW8hUSbtlXX0hGjcj9PYFv0tA=;
        b=oamQfl66UbVEsFNOsd9giC4IzS68piNn2uRwrd+RbimBJBOSiskxXQssCcuW2FZK6b
         jswgytSIIn8jaESJ9MbeulCPpH/K6kWh0oJqrpzJpzM4EcVg3R7vrvVq9rmku3bItPEf
         B7XzpI8+wq1Tvgg3vbx9NB74WfLIhZhdRRuSov63vlHkwMFrbRuhqLIIx1ZU/bLluJzg
         UU+5mqa448ddBzzPEmKCWHyDCiY0py9QFKNeUuhELqQhK3kprqOHujS0GAx8hyPsRW+9
         I9Pe8efl4DzRDizmDy3HSwlsz3p0ipJP+xi2XuXG2lox4LVvexD/lRe1mtMiJiBVgimv
         xhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=rpP/s7RO4bOALLBaZXMW8hUSbtlXX0hGjcj9PYFv0tA=;
        b=cNbPARhxDfY1MV52cSnqobtWzaVlUqdQf4jO68FqtBwSM86YlK97e7hOR+psjNs1Go
         tXn6c933Gc1Vpimw2NmYNi+rQCsze6yexZhkd3HvaN/J2/jmkZuE0sQFGNg7O/E9iiD7
         2jaU6DszfbGRIZQVGT6p9pHIpt1r87rvtVnY0Agzmppd7E2VMmJtWIwALX9TWlUAp7/+
         bqOvRQuKid74Lv332Xixk+NxY1ZXxW/Qt4zbqLwKrTKiTSanof3rsBcmPfTgq5/eBoaK
         KKALM7MT/C3uRn3whZ3CWgzfdMEJsg+10VkbzmZJIhgXA2DlOzrY9CT28u1BDUhQLWFP
         lWnw==
X-Gm-Message-State: AOAM532eqrXpARgWJkp//bf2Hyxrd+uaDmTZ5kowmhh3jRhiUEyf6DuN
        KblRQ+go4cG2gmCuAtkGavakqoAI95UeMuAP3TqQ/o8OSx+6hQ==
X-Google-Smtp-Source: ABdhPJzMhxmCP/iXf62vhI1tImObcr50/JIQgIxmHCqgqGjdK7se4bMRHyTaDouxYckYCAwXlseDxv74eIKORaDeSK0=
X-Received: by 2002:ac8:7f86:: with SMTP id z6mr27157974qtj.162.1638626059406;
 Sat, 04 Dec 2021 05:54:19 -0800 (PST)
MIME-Version: 1.0
From:   Nathaniel McCallum <nathaniel@profian.com>
Date:   Sat, 4 Dec 2021 08:54:08 -0500
Message-ID: <CAHAy0tS9PXgb4cRFEZNEYpiwPVV3CpBRFQhbFN=+XXy=MQakRg@mail.gmail.com>
Subject: Possible Regression: 5.14.18 => 5.15.6
To:     linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

We are seeing a possible regression between 5.14.18 and 5.15.6. Our
trace logging shows the following output:

enclave location: 00007f3c00000000-00007f3c80000000
creating enclave: Secs { size: 2147483648, baseaddr: 139895674765312,
ssaframesize: 1, miscselect: (empty), attributes: Attributes {
features: MODE64BIT, xfrm: X87 | SSE }, pid: 0, svn: 0 }
adding pages: 00007f3c00000000-00007f3c00004000 R
adding pages: 00007f3c00004000-00007f3c0000c000 RW
adding pages: 00007f3c0000c000-00007f3c00039000 RX
adding pages: 00007f3c00201000-00007f3c003fc000 RW
adding pages: 00007f3c003fc000-00007f3c003fd000 T
adding pages: 00007f3c003fd000-00007f3c00400000 RW
adding pages: 00007f3c00400000-00007f3c00401000 R
adding pages: 00007f3c00401000-00007f3c00402000 RX
adding pages: 00007f3c00402000-00007f3c00403000 R
adding pages: 00007f3c00403000-00007f3c00404000 RW
enclave initialized
remapping: 00007f3c00000000-00007f3c00004000 R
remapping: 00007f3c00004000-00007f3c0000c000 RW
remapping: 00007f3c0000c000-00007f3c00039000 RX
Error: Operation not permitted (os error 1)

Using strace shows this:
...
mmap(0x7f6e80000000, 16384, PROT_READ, MAP_SHARED|MAP_FIXED, 3, 0) =
0x7f6e80000000
mmap(0x7f6e80004000, 32768, PROT_READ|PROT_WRITE,
MAP_SHARED|MAP_FIXED, 3, 0) = 0x7f6e80004000
mmap(0x7f6e8000c000, 184320, PROT_READ|PROT_EXEC,
MAP_SHARED|MAP_FIXED, 3, 0) = -1 EPERM (Operation not permitted)

We've followed the selftest structure pretty closely. The first two
remapping calls succeed, but the third one fails. This works on
5.14.18, but fails on 5.15.6.
