Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6916C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 02:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C88396101A
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 02:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbhI1CPY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 27 Sep 2021 22:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238512AbhI1CPY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 27 Sep 2021 22:15:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AEED6120F;
        Tue, 28 Sep 2021 02:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632795225;
        bh=P/zL4O0c1uXpFp8kSdRzhNqnIT5nB8gdNwyivu5WHkE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Vmona2j3FQOVnxsYqPTLTnwkmXzmb+etU7M6nTSJf3SjwacU5k2CUB8Cg2zg0gVEa
         sC8dXs9yYp8bYAkgCJxBEBdEAkE7v4nhfq3eJbBpdLiVzGRI0EnQ3irFVzdNcRZVLL
         qWXZ2WbO6+bOy9wsq7UNWolS6nsaSulGoHhDbnn1iasRv45ArIhVxZ1MLV8eXBO7Sa
         uhBV2vmsO0/vg4yBCX5nj0N3ZHUUpd4RExCHgrtg9+GH7F4n56q5Jr8ouy6eZ4UFq+
         KZ+FbgSqRN1i+/Sa2BD1KeImVUFr+19itraBXvOieepPP1X4L0Z4b/CPJuAe6Ki/nt
         hVhzCGGkUx3Gw==
Message-ID: <5b6f9e266ec5456d2ef613f0999eb9855b289aab.camel@kernel.org>
Subject: Re: [PATCH v6 1/7] x86/sgx: Provide indication of life-cycle of EPC
 pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Date:   Tue, 28 Sep 2021 05:13:43 +0300
In-Reply-To: <fe8b68dd183b4350bb9c5372d587899b@intel.com>
References: <20210917213836.175138-1-tony.luck@intel.com>
         <20210922182123.200105-1-tony.luck@intel.com>
         <20210922182123.200105-2-tony.luck@intel.com>
         <5aa9e385b38ce0f63d6b531ede2baafd17fc7861.camel@kernel.org>
         <42f4b668b5abe818295d804d43c077e5d3cb4a4c.camel@kernel.org>
         <YUznjYO0TZuorE/2@agluck-desk2.amr.corp.intel.com>
         <fe8b68dd183b4350bb9c5372d587899b@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-09-23 at 22:11 +0000, Luck, Tony wrote:
> > That's nice. It avoids having to create a fictitious owner for
> > the dirty pages, and for the sgx_alloc_va_page() case. Which
> > in turn means that the owner field in struct sgx_epc_page can
> > remain as "struct sgx_encl_page *owner;" (neatly avoiding DaveH's
> > request that it be an anonymous union of all the possible types,
> > because it is back to just being one type).
> >=20
> > Thanks!  Will include in next version.
>=20
> Also avoids a bunch of refactoring to make sure to set the owner field
> while holding zone->lock.
>=20
> I roughly coded it up and the old part 0001 was:
>=20
>  arch/x86/kernel/cpu/sgx/encl.c  |    5 +++--
>  arch/x86/kernel/cpu/sgx/encl.h  |    2 +-
>  arch/x86/kernel/cpu/sgx/ioctl.c |    2 +-
>  arch/x86/kernel/cpu/sgx/main.c  |   21 +++++++++++----------
>  arch/x86/kernel/cpu/sgx/sgx.h   |    4 ++--
>  5 files changed, 18 insertions(+), 16 deletions(-)
>=20
> which is by no means huge, but the new part 0001 is
>=20
>  arch/x86/kernel/cpu/sgx/main.c |    4 +++-
>  arch/x86/kernel/cpu/sgx/sgx.h  |    3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>=20
> -Tony

This is good to hear. I guess it is then a no brainer to move into
this direction then.

/Jarkko

