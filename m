Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD6CC433EF
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jun 2022 08:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbiFGI2R (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jun 2022 04:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiFGI2P (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Jun 2022 04:28:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41EA51309
        for <linux-sgx@vger.kernel.org>; Tue,  7 Jun 2022 01:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 238FA6168B
        for <linux-sgx@vger.kernel.org>; Tue,  7 Jun 2022 08:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3247AC34115;
        Tue,  7 Jun 2022 08:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654590493;
        bh=WlRmYJ4dyy4hJ2GsfTsytA9TNw2MzdvgWO2mLWYpDEQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UBWlY8M2b2T+jNOz2+UZcvZV6m5RMr4rhMgsbtx7wa35ffI3HX7cMMd1hh1JS2Lzu
         OITi/nIOcGSg1WwER6xcD3twIAyIWsshly8YTjyG4aIJVpMqdq0D2Djrol2pCF0nAy
         CNpVxqY0NUFxzJy9nwtHgqedSp9WzgFX3mafojOPCyJkrPokOkafIah/WXzIzN7VFt
         GOGjHeAVzphBYDcjPysBdcis6yziKn6Os/NhCu+Ptg++aMyWUuj93sJw2kMCsGOsWQ
         mYO9WrNwLs7PbOomrVykl9g1k0p/Hm73NG5f2EdmCQbfyCOlVR1c8O50xtgS51Pf5s
         RESpccYsufHbg==
Message-ID: <41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org>
Subject: Re: [PATCH v3 0/3] x86/sgx: fine grained SGX MCA behavior
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>,
        Kai Huang <kai.huang@intel.com>, "Du, Fan" <fan.du@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>
Date:   Tue, 07 Jun 2022 11:26:17 +0300
In-Reply-To: <0350d13c-0122-365d-11cb-eca004b411ca@intel.com>
References: <20220525100604.760576-1-zhiquan1.li@intel.com>
         <f239a63d32cb8b3d8d6730dac940a51e92831828.camel@kernel.org>
         <MN0PR11MB6181099B27E37C05659A30B199A19@MN0PR11MB6181.namprd11.prod.outlook.com>
         <ccfc5dacc80454e35b0f13410abc8606832f7517.camel@intel.com>
         <86eb19b512771098136e43fcdac95be8646357e4.camel@kernel.org>
         <0350d13c-0122-365d-11cb-eca004b411ca@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2022-06-07 at 15:02 +0800, Zhiquan Li wrote:
> On 2022/6/7 14:35, Jarkko Sakkinen wrote:
> > Considering Zhiquan's series: all the patches have different message ID=
,
> > which puts them into different threads and makes it hard to apply.
> >=20
> > E.g.
> >=20
> > https://lore.kernel.org/linux-sgx/20220525100625.760633-1-zhiquan1.li@i=
ntel.com/T/#u
> >=20
> > https://lore.kernel.org/linux-sgx/20220525100730.760815-1-zhiquan1.li@i=
ntel.com/T/#u
> >=20
> > Zhiquan: can you send your patch series as a single series? Easiest
> > way to do it is to use git send-email. Right now the series broken.
>=20
> Thanks for the heads up.
>=20
> I was not aware of the patch series are broken on https://lore.kernel.org=
/.
> I do use git send-email, there must be some settings are wrong,
> let me check my git config.
> Sorry for the inconvenience.

No worries, just look at the main page at lore for sgx, and you
see immediately the issue :-)=20

One more thing.

I think Tony hinted me about mechanism to test MCA behaviour in
kernel but I cannot recall it anymore. Was there a way to make
to simulate a memory failure, and use that to test the patch
set?


> Best Regards,
> Zhiquan

BR, Jarkko
