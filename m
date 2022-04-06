Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140D5C433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Apr 2022 10:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240429AbiDFKGv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Apr 2022 06:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242898AbiDFKFr (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 6 Apr 2022 06:05:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5323FC6F39;
        Tue,  5 Apr 2022 23:34:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED678B82004;
        Wed,  6 Apr 2022 06:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F916C385A3;
        Wed,  6 Apr 2022 06:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649226869;
        bh=j8Bbr8SxyGFgP/t5KjulfykSz32ZOIXqvVa5Dy0jbAs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IvgHP220bTg4KbFtDKm8zswOftdDwpyEFp7GfbtpWZwKk3F1UzXI5P0s1PkiUcwvW
         vChVuAielCq5oaURT1xdihz3lt25o+snRJCvBq3Sh9Ugr1GtR2x+rJ7Qg8q+ifLcfB
         T0lCKZe1ok7Wv4raZXA6NYQbeYP5yRpaB+fOs6GX4/QtlwQjRnhTY9Q9qjBlDbPrs7
         oW+h9GFxKO1Quz/C4R5oFZE/tpBE8WdBRmaCdgiygOO/okyKMZNBN27xqWKgcJt2MV
         z2PdeUK0SpVHUCDIt0q6t8ShcVUe008UaPU/+qtCik1eROAyjPDYlJ1/kDRCj+P1yF
         Fgu+U1/JZ7g7g==
Message-ID: <984834578beba18fa5b0196a0d9e4327dc22cf73.camel@kernel.org>
Subject: Re: [PATCH V3 19/30] x86/sgx: Free up EPC pages directly to support
 large page ranges
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        luto@kernel.org, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org, seanjc@google.com, kai.huang@intel.com,
        cathy.zhang@intel.com, cedric.xing@intel.com,
        haitao.huang@intel.com, mark.shanahan@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Date:   Wed, 06 Apr 2022 09:35:39 +0300
In-Reply-To: <f8d92685-27dd-e7ef-ce0d-100a285aec4b@intel.com>
References: <cover.1648847675.git.reinette.chatre@intel.com>
         <b3a17e1ce7bcd14db3c28903e8a97f094998ae74.1648847675.git.reinette.chatre@intel.com>
         <Ykvrk4hYvBEnNOOl@kernel.org>
         <e118f4c6-7216-15f3-2bda-3a5851b0bcb1@intel.com>
         <f8d92685-27dd-e7ef-ce0d-100a285aec4b@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2022-04-05 at 10:25 -0700, Dave Hansen wrote:
> On 4/5/22 10:13, Reinette Chatre wrote:
> > > > +void sgx_direct_reclaim(void)
> > > > +{
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (sgx_should_reclaim(S=
GX_NR_LOW_PAGES))
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0sgx_reclaim_pages();
> > > > +}
> > > Please, instead open code this to both locations - not enough redunda=
ncy
> > > to be worth of new function. Causes only unnecessary cross-referencin=
g
> > > when maintaining. Otherwise, I agree with the idea.
> > >=20
> > hmmm, that means the heart of the reclaimer (sgx_reclaim_pages()) would=
 be
> > made available for direct use from everywhere in the driver. I will loo=
k into this.
>=20
> I like the change.=C2=A0 It's not about reducing code redundancy, it's ab=
out
> *describing* what the code does.=C2=A0 Each location could have:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Enter direct SGX recla=
im: */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (sgx_should_reclaim(SG=
X_NR_LOW_PAGES))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0sgx_reclaim_pages();
>=20
> Or, it could just be:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_direct_reclaim();
>=20
> Which also provides a logical choke point to add comments, like:
>=20
> /*
> =C2=A0* sgx_direct_reclaim() should be called in locations where SGX
> =C2=A0* memory resources might be low and might be needed in order
> =C2=A0* to make forward progress.
> =C2=A0*/
> void sgx_direct_reclaim(void)
> {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0...

Maybe cutting hairs but could it be "sgx_reclaim_direct"? Rationale
is easier grepping of reclaimer functions, e.g. when tracing.

BR, Jarkko
