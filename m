Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336C1C433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Sep 2021 21:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12A8160FE8
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Sep 2021 21:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhIUV3t (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 21 Sep 2021 17:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235066AbhIUV3r (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 21 Sep 2021 17:29:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6885560E05;
        Tue, 21 Sep 2021 21:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632259698;
        bh=u5KDp5z7CNOMtmug5vUpsYUjL+QlsT/yr8SkHYUNkzA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k5/YG+yIhh+2Lmbf7o19vG38h1Ui+/ljTE8INnNZUhwDqxRBEaKYNGqz4ovOw2qC6
         oW0K574xRPFLgi6j7219P63O7HYnSLn+J4ER9euN7lliQZKglCHW13+OMIrfmd3CFr
         HHKTkvDLZFueAOZsNP6wwOWlr6FyTApV4NHsK/lfJa49eF2m8S699Y/ZYHVOwhwdtK
         puOJB6MSGQmkw7cTiME9Fp8D7hVJ5ZObWvmueFr7vGvlqZ3P0Z1c/NEo9XypkQkxd0
         4ZYXP9p6xLS12/zTcnhNl1VS4N0us1PEu/e7H5zmrbvocDsRUV2yXEUes8jbWHt91J
         pBDQPbTK+dH5A==
Message-ID: <bba7e537fd9197a92358640ebb0aef365984cebc.camel@kernel.org>
Subject: Re: [PATCH v5 1/7] x86/sgx: Provide indication of life-cycle of EPC
 pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 22 Sep 2021 00:28:16 +0300
In-Reply-To: <20210917213836.175138-2-tony.luck@intel.com>
References: <20210827195543.1667168-1-tony.luck@intel.com>
         <20210917213836.175138-1-tony.luck@intel.com>
         <20210917213836.175138-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2021-09-17 at 14:38 -0700, Tony Luck wrote:
> SGX EPC pages go through the following life cycle:
>=20
>         DIRTY ---> FREE ---> IN-USE --\
>                     ^                 |
>                     \-----------------/
>=20
> Recovery action for poison for a DIRTY or FREE page is simple. Just
> make sure never to allocate the page. IN-USE pages need some extra
> handling.
>=20
> It would be good to use the sgx_epc_page->owner field as an indicator
> of where an EPC page is currently in that cycle (owner !=3D NULL means
> the EPC page is IN-USE). But there is one caller, sgx_alloc_va_page(),
> that calls with NULL.
>=20
> Since there are multiple uses of the "owner" field with different types
> change the sgx_epc_page structure to define an anonymous union with
> each of the uses explicitly called out.

But it's still always a pointer.

And not only that, but two alternative fields in that union have *exactly* =
the
same type, so it's kind of artifically representing the problem more comple=
x
than it really is.

I'm not just getting, why all this complexity, and not a few casts instead?

I neither get the rename of "owner" to "private". It serves very little val=
ue.
I'm not saying that "owner" is best name ever but it's not *that* confusing
either. That I'm sure that it is definitely not very productive to rename i=
t.

Also there was still this "dirty". We could use ((void *)-1), which was als=
o
suggested for earlier revisions.

/Jarkko

