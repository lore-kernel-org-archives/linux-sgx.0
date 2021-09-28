Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643C0C433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 02:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D1DB61247
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 02:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238598AbhI1CsL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 27 Sep 2021 22:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238590AbhI1CsL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 27 Sep 2021 22:48:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E370760F58;
        Tue, 28 Sep 2021 02:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632797192;
        bh=PZER7YMVtcPypyNSdvudby0m9vndgnG1A3LqnHmWv6I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c5y3zFH6aseCFQLknJpNFB/FOMZ2gElgegvFAVcV8AUaj/dp7ZpgVGB/dzyiq3m7U
         jrJEm5jZgsPepcLTfG9+/AltMy4T4i2nRi8VtxKiBcNuZdySoeBlX6n/IdMsFer2FD
         NmJ0rzk9GfQNsKFmVUrEjI+Vh+QIx+lQv5iAzLaGjDoGyRMfiuYDGY4LX3dYss13O+
         fiZ1kzthxsL+AOWqBuacuB19TeO7MtCxmHdCa2N2JPW9PEmoGn24nvYfZq8yhpT4bi
         Sl9zE1QXAKxReBUZTahOYwyyVRrRVH6STTuRCKAQJZwsux63DCcpLms/82w2ET0uAP
         X5t3idNN2GglQ==
Message-ID: <3efcda381b49651004e230f6ef008032842db1f9.camel@kernel.org>
Subject: Re: [PATCH v7 3/7] x86/sgx: Initial poison handling for dirty and
 free pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org
Date:   Tue, 28 Sep 2021 05:46:30 +0300
In-Reply-To: <20210927213452.212470-4-tony.luck@intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
         <20210927213452.212470-1-tony.luck@intel.com>
         <20210927213452.212470-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2021-09-27 at 14:34 -0700, Tony Luck wrote:
> A memory controller patrol scrubber can report poison in a page
> that isn't currently being used.
>=20
> Add "poison" field in the sgx_epc_page that can be set for an
> sgx_epc_page. Check for it:
> 1) When sanitizing dirty pages
> 2) When freeing epc pages
>=20
> Poison is a new field separated from flags to avoid having to make
> all updates to flags atomic, or integrate poison state changes into
> some other locking scheme to protect flags.
>=20
> In both cases place the poisoned page on a list of poisoned epc pages
> to make sure it will not be reallocated.
>=20
> Add debugfs files /sys/kernel/debug/sgx/poison_page_list so that system
> administrators get a list of those pages that have been dropped because
> of poison.

So, what would a sysadmin do with that detailed information?

I would decrease the granularity a bit rather add something like
this for each node:

	/sys/devices/system/node/node[0-9]*/sgx/poisoned_size

which would give the total amount of poisoned memory in bytes
for that node.

See the series that I've recently posted:

https://lore.kernel.org/linux-sgx/20210914030422.377601-1-jarkko@kernel.org=
/T/#t

/Jarkko

