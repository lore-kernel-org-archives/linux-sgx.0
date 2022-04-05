Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B48AC433F5
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Apr 2022 05:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiDEGAd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 5 Apr 2022 02:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiDEGAc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 5 Apr 2022 02:00:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6062A1A9
        for <linux-sgx@vger.kernel.org>; Mon,  4 Apr 2022 22:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FBDFB81B96
        for <linux-sgx@vger.kernel.org>; Tue,  5 Apr 2022 05:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8D5C340EE;
        Tue,  5 Apr 2022 05:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649138308;
        bh=pfMzOViYGW00TgIlYt3AQFCSB5N2dVpJByzTyYmWmNo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ct+BdZFAyAQsFnDeB+9Sk4G3G9tbjsgB4IFSckYJ8fZ7kO7SkI+O09qpL/Ie7uN+m
         IvgUkhrG2qa55GXwWwpmbW67LHhVxA9xOnJCL13FyexBIDD0g5Cj0ovGg6SXiubMwF
         uzPu9sHzDSQDoPynawTFkYHo2JJL9SLgG6O56ssfQvgjUn7bkRBPm3k3+2S8uSaG7t
         zWfo7ZbtgkW8UAX/YDLNtWLapStdXq3dPWN6dcFfySrDIf70n8/n8ndS0w1Ak6Fi9/
         x+PqQeF3gMgP7GLiFWwIIss+uLfi9G/BjT6ymEFpXzyYvCCL757LJDsj6UycvcKAoP
         ZZG1CIiFfHkCw==
Message-ID: <51e4905762c33ed10ca731f718f048d36d082dc0.camel@kernel.org>
Subject: Re: Odd looking #PF fault code
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        linux-sgx@vger.kernel.org
Cc:     dave.hansen@linux.intel.com
Date:   Tue, 05 Apr 2022 08:59:39 +0300
In-Reply-To: <3d2b5a6e-f59a-e5fc-9349-5449d6cc7267@intel.com>
References: <YkoyvdqIqkaOk8NL@kernel.org>
         <3d2b5a6e-f59a-e5fc-9349-5449d6cc7267@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2022-04-04 at 09:27 -0700, Reinette Chatre wrote:
> Hi Jarkko,
>=20
> On 4/3/2022 4:50 PM, Jarkko Sakkinen wrote:
> > I get this when trying to get EAUG-EACCEPTCOPY to run on Enarx and I ge=
t:
> >=20
>=20
> There seems a difference in the error codes described:
>=20
> > Unexpected PF: address: 0x007f7fff910000, error code 0x15
>=20
> Error code 0x15 translates to binary 10101 which is:
> BIT 0: Present
> BIT 2: User
> BIT 4: Instruction fetch

Yeah, I misread it.

BR, Jarkko
