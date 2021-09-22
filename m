Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF70C433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Sep 2021 05:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 167B7611C6
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Sep 2021 05:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhIVF3b (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 Sep 2021 01:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231896AbhIVF3a (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 22 Sep 2021 01:29:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8AAE6112F;
        Wed, 22 Sep 2021 05:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632288481;
        bh=BPl0WzWMl37d2k/3uxnnOLpKXcWTjHJrAMlccHcUi5M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O3eF/e2/0vcG+/9vQrsuSFgUTFzVDba4jm4/FNqlLUicDRXpJqgLL7lvHyy15F9vW
         DMhjanNmLTOAE6W5jpXpEkvu2a/TBx/aqaBX3pePBlkkcNwNHSzvy4B1hOW3jM0Hzi
         3xi54CSK8rLYg9BdUsijZ/9Efmh9qE3MUU6AmdIiDI07RHiUVgfsAhcdkOb3e5aN6x
         URvrhK8Uv7GLcEGg+Yf+gURtdLv62pSAnRL6IVlFEfzf/dN3BLm4/ZLrQtreldV9TC
         nYn/MyxaE086qtfLfDao1tKwZkjbp4ucLP9npFh4LyF4//OOPg1IZtp6nI2PpNEpNf
         XTF4CfJh4Fo/w==
Message-ID: <931e05840165b8285acf8d13ded01fb233b6549c.camel@kernel.org>
Subject: Re: [PATCH v5 1/7] x86/sgx: Provide indication of life-cycle of EPC
 pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 22 Sep 2021 08:27:58 +0300
In-Reply-To: <057511a3-3bc8-f073-e0f8-7b14646f82fe@intel.com>
References: <20210827195543.1667168-1-tony.luck@intel.com>
         <20210917213836.175138-1-tony.luck@intel.com>
         <20210917213836.175138-2-tony.luck@intel.com>
         <bba7e537fd9197a92358640ebb0aef365984cebc.camel@kernel.org>
         <057511a3-3bc8-f073-e0f8-7b14646f82fe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2021-09-21 at 15:15 -0700, Dave Hansen wrote:
> On 9/21/21 2:28 PM, Jarkko Sakkinen wrote:
> > > Since there are multiple uses of the "owner" field with different typ=
es
> > > change the sgx_epc_page structure to define an anonymous union with
> > > each of the uses explicitly called out.
> > But it's still always a pointer.
> >=20
> > And not only that, but two alternative fields in that union have *exact=
ly* the
> > same type, so it's kind of artifically representing the problem more co=
mplex
> > than it really is.
> >=20
> > I'm not just getting, why all this complexity, and not a few casts inst=
ead?
>=20
> I suggested this.  It makes the structure more self-describing because
> it explicitly lists the possibles uses of the space in the structure.
>=20
> Maybe I stare at 'struct page' and its 4 unions too much and I'm
> enamored by their shininess.  But, in the end, I prefer unions to casting=
.

Yeah, packing data into constrained space (as in the case of struct page) i=
s
the only application for, where you can speak of a quantitative decision, w=
hen
you pick union.

/Jarkko

