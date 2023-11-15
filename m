Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D3DC072A2
	for <linux-sgx@archiver.kernel.org>; Wed, 15 Nov 2023 21:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjKOV0h (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 Nov 2023 16:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbjKOV0h (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 15 Nov 2023 16:26:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8A5B7;
        Wed, 15 Nov 2023 13:26:34 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E69C433C8;
        Wed, 15 Nov 2023 21:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700083593;
        bh=C3+IGnleHpuqWrhtGTuOPsQYKcoXanjycNfvv/yiAKc=;
        h=Date:To:Subject:From:References:In-Reply-To:From;
        b=fGHqONqhHM6ytddaKyxTGM6Wo7ras659epQ7atDIEqClEfn1qq67vub8wn9RCdvJ8
         IFIH/lfaelQGBxYlR1av4SH44ntIcG0upc2khHvYt3ChkH/7JIPVvskGqFT4plqkZk
         kbncQ+AlTO9U5KaepBplxDSaSo1GL8l2SdNaDBnSfdMBjyjl3HYTFUjad5yx6HaRay
         kOpQXLha5nLB/wme56bOTIPtwHMt+6GPIE+H4JVOVmlV/aIDlJImictvM/XXynueYz
         1QH0GuMdSwvWfFpIz5OxZnQ85MT0WRtlUdDaYX1W1mtvl2HbTy3jJPRpPXz1/dH6en
         alAN3AGuALXmQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 15 Nov 2023 23:26:30 +0200
Message-Id: <CWZPC3OVW936.J3V6VT5BK0DD@kernel.org>
To:     "Jo Van Bulck" <jo.vanbulck@kuleuven.be>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 00/13] selftests/sgx: Fix compilation errors
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
X-Mailer: aerc 0.15.2
References: <20231005153854.25566-1-jo.vanbulck@cs.kuleuven.be>
 <119aaa2820be5dc58144e74574cfaa7777f79604.camel@intel.com>
 <f2726c67-87f7-409a-9ac2-e845249348cc@cs.kuleuven.be>
 <7e729488e2f841f384b719d0509a4f78f491d477.camel@kernel.org>
 <be63771f-080e-4832-955e-13f5b06b2010@kuleuven.be>
 <CWG522A78YHD.37CO0T9F3FVXB@suppilovahvero>
 <55d6aa33-4ffd-4a0c-a449-63b136f5a1a9@kuleuven.be>
In-Reply-To: <55d6aa33-4ffd-4a0c-a449-63b136f5a1a9@kuleuven.be>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed Nov 8, 2023 at 10:31 PM EET, Jo Van Bulck wrote:
> On 23.10.23 23:32, Jarkko Sakkinen wrote:
> > On Fri Oct 13, 2023 at 2:45 PM EEST, Jo Van Bulck wrote:
> >> On 10.10.23 11:44, Jarkko Sakkinen wrote:
> >>> Folks (sorry for top posting): I've now taken my old NUC7 out of the
> >>> dust and tested the series :-)
> >>>
> >>> Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
> >>
> >> Thanks for testing this Jarkko! Not sure on next steps, do you want me
> >> to re-post the series with the Tested-by tag for all commits or will y=
ou
> >> add that? Let me know if something from my side is needed.
> >=20
> > Dave, can you pick these patches to the x86 tree with my tested-by
> > added? Sorry for latency. It is flu season in Finland and I've been
> > functional varying last week because of that.
>
> Just a kind follow-up: from what I can see, this series has not been=20
> merged into the x86/sgx branch of tip yet (assuming that's where it=20
> should go next)?
>
> Apologies if I've overlooked anything, and please let me know if there's=
=20
> something on my end that can help!

I'm cool merging them so it is now up to Dave to pick them into the
tip tree.

> Best,
> Jo

BR, Jarkko
