Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E48C433EF
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Nov 2021 22:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71951613D3
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Nov 2021 22:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbhKGWba (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Nov 2021 17:31:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235737AbhKGWba (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Nov 2021 17:31:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF92160FC1;
        Sun,  7 Nov 2021 22:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636324127;
        bh=krHjZde3Mzk8M9q+BC9UiS9WyWY8AUbQTr3wGFrGymQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W4iMrHYYg+3xIc9+m7TKvPzrmWWx7cjsn+xzFs6CHOvC1CxuDyATh0Z2PLk5Wi66N
         Iv2trrFaBNI7gdOfGcusurNtm1enXA+eJxJEeUYjedLHlh7bI3HPirRrlRSoDTGrCJ
         n8OUcbwjyyYy6XfVs4cEkPLLrNW9QUnshqAzBuZ3FXsk7boODjhIENXNsIclk0mjXM
         DMgz9lTSnEERiVFep+dSb+PKLzbAjD3lFaBkbOjHNRiNG2cY4tXpEx401TXe5fJSfR
         ZSCebsWHw0LJ3ldpXB4AED4CyOBpCPoXJpzGFi4OCYvOyzT2TJwAiMWRCvtAwxsNKT
         ncs1R1Fq78uqQ==
Message-ID: <186120e4754fa0b583d5f4cb31aa49ccd5795d09.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Free backing memory after faulting the enclave
 page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>,
        reinette.chatre@intel.com, tony.luck@intel.com,
        nathaniel@profian.com, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 08 Nov 2021 00:28:44 +0200
In-Reply-To: <7a5d6dab-4d06-40b3-d9c7-09c991b856cd@intel.com>
References: <20211103232238.110557-1-jarkko@kernel.org>
         <6831ed3c-c5b1-64f7-2ad7-f2d686224b7e@intel.com>
         <e88d6d580354aadaa8eaa5ee6fa703f021786afb.camel@kernel.org>
         <d2191571-30a5-c2aa-e8ed-0a380e9daeac@intel.com>
         <55eb8f3649590289a0f2b1ebe7583b6da3ff70ee.camel@kernel.org>
         <c6f5356b-a56a-e057-ef74-74e1169a844b@intel.com> <YYgsL7xSxnsjqIlu@iki.fi>
         <7a5d6dab-4d06-40b3-d9c7-09c991b856cd@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, 2021-11-07 at 11:51 -0800, Dave Hansen wrote:
> On 11/7/21 11:42 AM, Jarkko Sakkinen wrote:
> > > > It should be fairly effecient just to check the pages by using
> > > > encl->page_tree.
> > > That sounds more complicated and slower than what I suggested.=C2=A0 =
You
> > > could even just check the refcount on the page.=C2=A0 I _think_ page =
cache
> > > pages have a refcount of 2.=C2=A0 So, look for the refcount that mean=
s "no
> > > more PCMD in this page", and just free it if so.
> > Umh, so... there is total 32 PCMD's per one page.
>=20
> When you place PCMD in a page, you do a get_page().=C2=A0 The refcount go=
es
> up by one.=C2=A0 So, a PCMD page with one PCMD will (I think) have a refc=
ount
> of 3.=C2=A0 If you totally fill it up with 31 *more* PCMD entries, it wil=
l
> have a refcount of 34.=C2=A0 You do *not* do a put_page() on the PCMD pag=
e at
> the end of the allocation phase.
>=20
> When the backing storage is freed, you drop the refcount.=C2=A0 So, going
> from 32 PCMD entries to 31 entries in a page, you go from 34->33.
>=20
> When that refcount drops to 2, you know there is no more data in the
> page that's useful.=C2=A0 At that point you can truncate it out of the
> backing storage.
>=20
> There's no reason to scan the page, or a boatload of other metadata.
> Just keep a refcount.=C2=A0 Just use the *existing* 'struct page' refcoun=
t.

Right! Thank you, I'll use this approach, and check that the refcount
actually behaves that way you described.

/Jarkko
