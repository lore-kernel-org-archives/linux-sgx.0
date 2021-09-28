Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02805C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 20:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D480A61206
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 20:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242696AbhI1UNN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 28 Sep 2021 16:13:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242702AbhI1UNM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 28 Sep 2021 16:13:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37A6B61157;
        Tue, 28 Sep 2021 20:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632859892;
        bh=t6wuufIz0WGpNIr4elQUchovJtkoBoNg0a6gKLSqEqU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Lyey0cb4lERlN7lWwmKDr9Msj/l75LMcngV6NSTp8R/c5/Y5jf+0FopS7kpMo2rgp
         oPLikTyGAfRAxiUWsZ/vjBXN6o9qW25NQaPC2pF10KK95RJVToyjr0zefPtjuqPy98
         AwFcf4A2xkNerM6DwRDjSiRZk5QTWO5mRQzjLLDo6r5k4FnbRcpOlTYcx71Uq0Uw/q
         DrLYzC92SgpctRG/poVhmTHr0x1OWetMaXUoiw7ZfExg5jM7JKrOv9+Hq4K3QdrkHR
         hzNo0tcxi5ywcI+BXr7NmBrzuHIcQQWv4LzQ28YZ23apcHKbmFDdLWpoGfR9xDU6MS
         imXpt+R6c0UJA==
Message-ID: <1702295227b9276e051a0efee8af1475cba27407.camel@kernel.org>
Subject: Re: [PATCH v7 3/7] x86/sgx: Initial poison handling for dirty and
 free pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Luck, Tony" <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Cc:     "Zhang, Cathy" <cathy.zhang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Date:   Tue, 28 Sep 2021 23:11:30 +0300
In-Reply-To: <ca3bb671a49141608ac981012091c3ea@intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
         <20210927213452.212470-1-tony.luck@intel.com>
         <20210927213452.212470-4-tony.luck@intel.com>
         <3efcda381b49651004e230f6ef008032842db1f9.camel@kernel.org>
         <ca3bb671a49141608ac981012091c3ea@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2021-09-28 at 15:41 +0000, Luck, Tony wrote:
> > > Add debugfs files /sys/kernel/debug/sgx/poison_page_list so that syst=
em
> > > administrators get a list of those pages that have been dropped becau=
se
> > > of poison.
> >=20
> > So, what would a sysadmin do with that detailed information?
>=20
> It's going to be a rare case that there are any poisoned pages on that li=
st
> (a large enough cluster will have some systems that have uncorrected
> recoverable errors in SGX EPC memory).
>=20
> Even when there are some poisoned pages, there will only be a few. System=
s
> that have thousands of pages with uncorrected memory errors will surely c=
rash
> because one of those errors is going to either trigger an error marked as=
 fatal,
> or the error won=E2=80=99t be recoverable by Linux because it is in kerne=
l memory.
>=20
> A sysadmin might add a script to run during system shutdown (or periodica=
lly
> during run-time) to save the poison page list. Then at startup run:
>=20
> for addr in `cat saved_sgx_poison_page_list`
> do
> 	echo $addr > /sys/devices/system/memory/hard_offline_page
> done
>=20
> to make poison persistent across reboots.
>=20
> -Tony

Couldn't it be a blob with 8 bytes for each address?

/Jarkko
