Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B257EB64D7
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Jun 2023 09:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjF3JgA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 30 Jun 2023 05:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbjF3Jf5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 30 Jun 2023 05:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152D8199D
        for <linux-sgx@vger.kernel.org>; Fri, 30 Jun 2023 02:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E2F761708
        for <linux-sgx@vger.kernel.org>; Fri, 30 Jun 2023 09:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427ABC433C8;
        Fri, 30 Jun 2023 09:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688117754;
        bh=D/MzlVl8dsFLrsJ1AtBczNjrNm7P2/LuXPLHGncDvJ0=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=nqrCvunEF5qNvvTjD7Sc0gF7UQSHgEJrz+26/Te75HYfRmsk1Kv3pzMj+rYbiwXLW
         7wjF/TK2tczHButWNokk/+Q5qwx8ku0yE5G36D1F5QEQf+iNSf9zBSNU7HIwF7xQdA
         cDQaiKAB8AEiUDPpOL/2GmU4dUyb+HjYBx2VnM/pNKlZCay8Wc+j30I1bto5roq6/0
         NYHajeRId3cYTK+3x4eOkxh2go30kore7++s6ewLLf5J+ifkX0sgV4bHLiUkllQPwt
         r8tB0CNMb4cR/GFKYJTPCzhAw+exsSrUYPIX7NJd1lw6F+n7FDUsIzGwUWb0dW6X3F
         SX6dF/tS8o9WA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 30 Jun 2023 12:35:49 +0300
Message-Id: <CTPVSS35UCBE.VH2NV1ZZ8NRN@suppilovahvero>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
X-Mailer: aerc 0.14.0
References: <ZIzcrmU1RA7oEeQ7@google.com>
 <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
 <ZJTEpH2yYtHmTRWr@google.com>
 <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
 <ZJoRHU1CHxIuDH29@google.com>
 <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
 <ZJr3PthzDgugKDcO@google.com>
 <1a980d3ce2caec1cf44bf97d52fa08fbe72e741f.camel@intel.com>
 <ZJxKV1/2M+OeIXAN@google.com>
 <60f96055b73932ef3550eb562d2f42440d534e69.camel@intel.com>
 <ZJ2T6zJSnLtKMPnE@google.com>
 <50913a11353b17861c13ebb53305dd370c8b8b43.camel@intel.com>
 <CTPLZCBDSLUU.1CPR6DL9J2GE9@suppilovahvero>
 <CTPM273Z6Y6S.36I8EUC0M72B7@suppilovahvero>
 <385c1567cb9de5c3af79295acd1d5195ee20e60c.camel@intel.com>
In-Reply-To: <385c1567cb9de5c3af79295acd1d5195ee20e60c.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri Jun 30, 2023 at 7:26 AM EEST, Huang, Kai wrote:
>
> >=20
> > Does this map to any of the runtimes that people *actually* use for
> > their workloads?
> >=20
>
> Haitao wants to use madvice(WILLNEED) to speed up EUG flow.  For the perf=
ormance
> data please look at the cover letter of this series.

Right thanks for reminding! Now in the same page.

> The whole discussion was about to get mmap(/dev/sgx_enclave) semantics cl=
arified
> so this series can move on and also future life can be easier.

+1

BR, Jarkko
