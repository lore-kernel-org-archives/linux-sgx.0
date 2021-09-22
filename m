Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30218C433F5
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Sep 2021 05:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0673E611B0
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Sep 2021 05:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhIVFTZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 Sep 2021 01:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231901AbhIVFTZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 22 Sep 2021 01:19:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2D92610A1;
        Wed, 22 Sep 2021 05:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632287876;
        bh=ds1qCLLEuGabOz1HUFOYzp9guoYj5j+uwCXOBzR2m9w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DClyx36BX/OOPtUePak882HjjOXz7eLKXMXAZzwLjIVOzjCKhWf33Zx0oiJX0fafI
         7vmxnwJbEguc65bJKbU8fq5AVNKhyrKqXYxEORPXyFSYBHu+akklyVwDUBAFuKXqlU
         Xz5gwfvmwFBQIe+UN3Rt8hyus+XTNzvPkxx+j+uQBxBnU+pahueN3D2L7TI1ZsaVOK
         G12L8Ct3jUCKudCL2ZfMxWlm1DAgglPYN+tK2Lj0DRWbwz6j0ywbs/ENQlvBFh6NsN
         tyOznLEzWmUOckNcOaRHwM/bscxR+PBcPm5zFHyVGFhaSAHum2DSVl0OhaETqE1oLp
         Eocjw+6dkAiCg==
Message-ID: <e0dff2e1bb7db0ededfa5a66826225e1358ed77f.camel@kernel.org>
Subject: Re: [PATCH v5 1/7] x86/sgx: Provide indication of life-cycle of EPC
 pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Luck, Tony" <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Cc:     "Zhang, Cathy" <cathy.zhang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Wed, 22 Sep 2021 08:17:53 +0300
In-Reply-To: <4c7351bcd03b4161b78a7dc01c795b43@intel.com>
References: <20210827195543.1667168-1-tony.luck@intel.com>
         <20210917213836.175138-1-tony.luck@intel.com>
         <20210917213836.175138-2-tony.luck@intel.com>
         <bba7e537fd9197a92358640ebb0aef365984cebc.camel@kernel.org>
         <4c7351bcd03b4161b78a7dc01c795b43@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2021-09-21 at 21:34 +0000, Luck, Tony wrote:
> > > Since there are multiple uses of the "owner" field with different typ=
es
> > > change the sgx_epc_page structure to define an anonymous union with
> > > each of the uses explicitly called out.
> >=20
> > But it's still always a pointer.
> >=20
> > And not only that, but two alternative fields in that union have *exact=
ly* the
> > same type, so it's kind of artifically representing the problem more co=
mplex
> > than it really is.
>=20
> Bother! I seem to have jumbled some old bits of v4 into this series.
>=20
> I agree that we just want "void *owner; here.  I even made the changes.
> Then managed to lose them while updating.
>=20
> I'll find the bits I lost and re-merge them in.
>=20
> -Tony

Yeah, ok, cool, thank you. Just reporting what I was observing :-)

/Jarkko

