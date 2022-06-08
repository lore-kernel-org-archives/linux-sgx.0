Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F5ACCA47E
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jun 2022 02:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384745AbiFHCqx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jun 2022 22:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447615AbiFHCl7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Jun 2022 22:41:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6E8196AB8
        for <linux-sgx@vger.kernel.org>; Tue,  7 Jun 2022 17:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0014DB82474
        for <linux-sgx@vger.kernel.org>; Wed,  8 Jun 2022 00:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0A9C3411C;
        Wed,  8 Jun 2022 00:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654647714;
        bh=5iyG8NpIPL8lbV8P0Uk/HAdI7kCxU5r1TifIAKRk/Co=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bKLwrzxs6RxC6MxLQ0cUESBB704+/C+xYzFwAWY46pSHiSnNVpi2y8R8spdcpIHsZ
         RlcM0mvj6YRPl4ePLTGgYQAZDXVUUgUJ9RdvHwrmsX/FcO3RJ7iUkIzA9pq21bs/yd
         HJaZnRufWDLUlZ+nk9Fpf+1DUKpAFqjNM2TIVlguairL7R6w7MizADd+j4tHXHyabl
         Nq7QQDalClztyfVVrMN/E4ZN1GpR6ymI92rRcTr6ta6Xb2dLh3A9VBF8aYYyxnJkUR
         RomXCAa5Dtr3K4F7mLQmksEHzDSaed9p0Xq8h1rsIoV6MVZu9XF5Bxa7bNI9vBlWT3
         QSlQWf0mtQ10w==
Message-ID: <d6e089d7f79d427e824efee0eb480c44ab71ad23.camel@kernel.org>
Subject: Re: [PATCH v3 0/3] x86/sgx: fine grained SGX MCA behavior
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>, "Du, Fan" <fan.du@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>
Date:   Wed, 08 Jun 2022 03:19:57 +0300
In-Reply-To: <e1c78d1a31234384a005736115906127@intel.com>
References: <20220525100604.760576-1-zhiquan1.li@intel.com>
         <f239a63d32cb8b3d8d6730dac940a51e92831828.camel@kernel.org>
         <MN0PR11MB6181099B27E37C05659A30B199A19@MN0PR11MB6181.namprd11.prod.outlook.com>
         <ccfc5dacc80454e35b0f13410abc8606832f7517.camel@intel.com>
         <86eb19b512771098136e43fcdac95be8646357e4.camel@kernel.org>
         <0350d13c-0122-365d-11cb-eca004b411ca@intel.com>
         <41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org>
         <e1c78d1a31234384a005736115906127@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2022-06-07 at 15:43 +0000, Luck, Tony wrote:
> > I think Tony hinted me about mechanism to test MCA behaviour in
> > kernel but I cannot recall it anymore. Was there a way to make
> > to simulate a memory failure, and use that to test the patch
> > set?
>=20
> It is possible to inject real errors into enclave memory using ACPI/EINJ.
> See the final part of:
>=20
> =C2=A0 Documentation/firmware-guide/acpi/apei/einj.rst
>=20
> You do a faked test by just asking to offline a page:
>=20
> # echo {pfn} > /sys/devices/system/memory/hard_offline_page

OK, I'll try this out in a VM. Thank you.

BR, Jarkko
