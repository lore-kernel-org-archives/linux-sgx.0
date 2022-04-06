Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32C7C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Apr 2022 10:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349690AbiDFKGC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Apr 2022 06:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343869AbiDFKFQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 6 Apr 2022 06:05:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9C6366B6
        for <linux-sgx@vger.kernel.org>; Tue,  5 Apr 2022 23:32:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12BDB619DD
        for <linux-sgx@vger.kernel.org>; Wed,  6 Apr 2022 06:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8C7C385A1;
        Wed,  6 Apr 2022 06:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649226772;
        bh=gTgDwB2i/rMALdjp4/LYOvrI1ffh18ptCz9EsZBs/lY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L/29im8AKJpM3oWZzoI2bNuBTOyl422BDQe3HFmzYg2YJmubQawUoaApA6GDLhil1
         OjWT5G5SHhPmGZfbstMBDVgd1E7LeYwCPWsnNTb09ziClOYYfG7/Hd8h8pOlp48bFe
         WP+r6NyGipe/NcEr7ugslECGM+rxK4llD1QYDFRzZCauymk3+f19A+shHjc929DgI3
         9jNLu629r/V09ELRBNsjf/bRiDOkHehPi8W7Q0vvMjQLc1L9kCEThjNLb8Ku11+C53
         TSMHZGU8hAi3aLthOna4ztT+vf0ZWTxPYeyrAVUDjW0tsc4sTcB8Z38HQvraxa969a
         1q20rpWAw56DA==
Message-ID: <b05d36962c6eaf7968329f833c73849700298bbc.camel@kernel.org>
Subject: Re: [RFC PATCH v3 05/10] x86/sgx: Save the size of each EPC section
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Zhang, Cathy" <cathy.zhang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Date:   Wed, 06 Apr 2022 09:34:02 +0300
In-Reply-To: <77a9e893ffe54dca9685b97cdf79b078@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
         <20220401142409.26215-6-cathy.zhang@intel.com>
         <YklzoObeCWk1AX5L@kernel.org> <77a9e893ffe54dca9685b97cdf79b078@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2022-04-06 at 04:00 +0000, Zhang, Cathy wrote:
>=20
>=20
> > -----Original Message-----
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > Sent: Sunday, April 3, 2022 6:15 PM
> > To: Zhang, Cathy <cathy.zhang@intel.com>
> > Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> > <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>; Raj,
> > Ashok <ashok.raj@intel.com>
> > Subject: Re: [RFC PATCH v3 05/10] x86/sgx: Save the size of each EPC se=
ction
> >=20
> > On Fri, Apr 01, 2022 at 10:24:04PM +0800, Cathy Zhang wrote:
> > > For SGX CPUSVN update process will check all EPC pages in each sectio=
n
> > > to ensure they will be marked as unused, it requires to know the size
> > > of each EPC section to end the loop.
> >=20
> > Why is the size required to end the loop? It's missing.
>=20
> How about re-write as follows:
>=20
> SGX CPUSVN update process should check all EPC pages to ensure they
> will be marked as unused. For EPC pages are stored in EPC sections,
> it's required to save the size of each section, as the indicator for
> the end of each section's traversing.

Sounds good to me.

BR, Jarkko
