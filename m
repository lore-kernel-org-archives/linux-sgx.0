Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7F1C41513
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Aug 2023 16:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbjHQQCc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Aug 2023 12:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353440AbjHQQCE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 17 Aug 2023 12:02:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376AB30F1
        for <linux-sgx@vger.kernel.org>; Thu, 17 Aug 2023 09:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C657C67523
        for <linux-sgx@vger.kernel.org>; Thu, 17 Aug 2023 16:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26776C433BF;
        Thu, 17 Aug 2023 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692288122;
        bh=KOFrx0L1xQJpxkZaQO7WPSPrunKiZrhrZZ9BYR+8wWI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PD6iRtLgLlKv2U/mkOboZApBU1NuI+UDOiqglqGc1dwT+apWo+L2EMZUgcwVtvm14
         4W2p9J9ySxe7/TaAnAyI9A63E1C+ZD139vN50egWjlTT10wC9V7faK8MaCHXAHD2rO
         cIuXOe1yDQgvCC9k88K2Icv8cz3+2fiaHbKrUjYudz+2t2DwAY0Y5ArRM3qcXFg4pY
         WXvZ+Tm5SZiOlYYrkWMxUzoTC1MTni5W1koOuBVOBsjrtt0nqGX2r4h2eqOH1XXrjn
         WGcyT3J70O9dADQWr8mdLQ8cD4SedqRmiCSXvdOpu73T5Jo2NC1QujgHwcyjaPi19Z
         kODCLFYLtEM5g==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 17 Aug 2023 16:01:59 +0000
Message-Id: <CUUY2LHIXLJO.2C4M4O5Q3SVCD@seitikki>
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "jinpu.wang@ionos.com" <jinpu.wang@ionos.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "yu.zhang@ionos.com" <yu.zhang@ionos.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
X-Mailer: aerc 0.14.0
References: <20230814043714.107971-1-jinpu.wang@ionos.com>
 <3954697abb1a6c84c4b30fbd0d5edcafae6f6966.camel@intel.com>
 <CAMGffEk_ojyRsMy_7d1R0aacwNQ0itDV+ZYTDH0Fpoy03iPkTg@mail.gmail.com>
 <3061b0ccb3a61b856498ebfc27d400250fa550c6.camel@intel.com>
In-Reply-To: <3061b0ccb3a61b856498ebfc27d400250fa550c6.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu Aug 17, 2023 at 10:00 AM UTC, Huang, Kai wrote:
> On Thu, 2023-08-17 at 09:38 +0200, Jinpu Wang wrote:
> > > This adds cond_resched() to the first two loops: releasing non-SECS p=
ages and
> > > releasing SECS pages which don't have children on remote vepc instanc=
e(s).
> > > There is a third round loop to release SECS pages which have children=
 on remote
> > > vepc instance(s).=C2=A0 I think it's better to add cond_resched() the=
re too, although
> > > it's extremely unlikely it could trigger softlockup w/o cond_resched(=
).
> >=20
> > I also think the third one are extremely unlikely could cause softlocku=
p.
> > And our tests do not hit it either.
>
> If we only consider your tests, then I believe you even don't need the se=
cond
> cond_resched()?
>
> I think we should just add cond_resched() to all the three loops.  No har=
m, and
> we don't need to worry about this anymore.

I'm fine with this.

BR, Jarkko
