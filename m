Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E42CC43334
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jun 2022 06:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiFGGhj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jun 2022 02:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiFGGhh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Jun 2022 02:37:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE40DEAE
        for <linux-sgx@vger.kernel.org>; Mon,  6 Jun 2022 23:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29B5DB81C98
        for <linux-sgx@vger.kernel.org>; Tue,  7 Jun 2022 06:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788ECC34115;
        Tue,  7 Jun 2022 06:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654583851;
        bh=29G0XrNDB4ZPKZYlSheiHbHAXL4VkG/k+KXxiMH82ek=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YJT2CTQFrc22H1RThcfyjs5BSnLZc5bZ0am7RaL5MW3f4ZAaKDLHm4yYlg22Dy6TS
         RQZMDTl+Y0SbLswhRKcghZfVn88vPEmhEX/HC9i6X1cxkuT9Dmbu+UoxXj6F6+yalP
         tlKpiZNAS5fLVAB/+bElpEXGqOPm+Z0lDeTo3/3lN9dXyznuUI3AhJOUp11x5B9Eqf
         b6Yeed+PmeDUSgGuuBTwCqoFW5FTK2RC24ltox/tFLVNtJ/bsrHdxTU4NZuL1Js5BR
         AkgNcAUtgI29RiobC2N+MPkELPXo6713eKgWT3VKd+MeGFJ3E67sLGhiMpVp3q80p6
         ldZ1zBvdXA0cw==
Message-ID: <86eb19b512771098136e43fcdac95be8646357e4.camel@kernel.org>
Subject: Re: [PATCH v3 0/3] x86/sgx: fine grained SGX MCA behavior
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>, "Du, Fan" <fan.du@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>
Date:   Tue, 07 Jun 2022 09:35:36 +0300
In-Reply-To: <ccfc5dacc80454e35b0f13410abc8606832f7517.camel@intel.com>
References: <20220525100604.760576-1-zhiquan1.li@intel.com>
         <f239a63d32cb8b3d8d6730dac940a51e92831828.camel@kernel.org>
         <MN0PR11MB6181099B27E37C05659A30B199A19@MN0PR11MB6181.namprd11.prod.outlook.com>
         <ccfc5dacc80454e35b0f13410abc8606832f7517.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2022-06-06 at 22:40 +1200, Kai Huang wrote:
> On Fri, 2022-06-03 at 13:15 +1200, Du, Fan wrote:
> > >=20
> > > This applies on top of Cathy's series, right? Why not send one
> > > series with all 12 patches included?
> > >=20
> > > It makes reviewing easier, and we are well beyond 5.19 timeline
> > > for these features.
> >=20
> > Patches from Zhiquan try to improve SGX MCA handling, actually this is =
a BUG
> > being
> > discussed with customer with SGX deployment already - SGX VM instance g=
ot
> > killed
> > in case of SGX application inside VM consumed poison EPC pages. Expecte=
d
> > behavior:
> > SGX application get killed only in such scenario.
> >=20
> > Seamless patchset from Catchy is another standalone feature, the design=
 seems
> > still under discussion. Combining those two distinct purpose-built patc=
hset
> > together
> > looks wired.
>=20
> Right.=C2=A0 Those are two different features and I don't see why they sh=
ould be sent
> out together.
>=20
> Btw, please also note Cathy's SGX rebootless recovery may never get accep=
ted:
>=20
> https://lore.kernel.org/linux-sgx/Yo0xSNt0JKGgOG59@zn.tnic/T/#m4d1a56fc3e=
d547d200443dab50bed6484e6d2e1d
> https://lore.kernel.org/all/20220524185324.28395-1-bp@alien8.de/

Considering Zhiquan's series: all the patches have different message ID,
which puts them into different threads and makes it hard to apply.

E.g.

https://lore.kernel.org/linux-sgx/20220525100625.760633-1-zhiquan1.li@intel=
.com/T/#u

https://lore.kernel.org/linux-sgx/20220525100730.760815-1-zhiquan1.li@intel=
.com/T/#u

Zhiquan: can you send your patch series as a single series? Easiest
way to do it is to use git send-email. Right now the series broken.

BR, Jarkko
