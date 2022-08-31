Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C18ECAAD1
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Aug 2022 18:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiHaSrv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Aug 2022 14:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbiHaSru (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 31 Aug 2022 14:47:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E2B4BD21
        for <linux-sgx@vger.kernel.org>; Wed, 31 Aug 2022 11:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F4CCB8228B
        for <linux-sgx@vger.kernel.org>; Wed, 31 Aug 2022 18:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB19DC433D6;
        Wed, 31 Aug 2022 18:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661971667;
        bh=1A25MTKV2KJAWAgXmkEq/1SPC5GBe6eDOxOkMVP0nDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IBUp/jPQYeOmb0sUncU9hTngE4RVcF81CgJdoLAsGGIEJkDEuqFteAVEFWxTzJ6/e
         lFPxG1N6qgFZMpl4SG0lzejv9PLvg1lpHvRDtCIS5Lg5RRDcJqKhV1k9K8e04XXvYQ
         x1LSB7/QcMQbJfgWKGB0aL/tlDvshWLRW+spoW+Z6g8feq22c99JR8l8uGHE7nzW7K
         76qn3jd5WsBNVQa8yn/HwTtpiLVulZ69R+Zke8NfdFKSGuLcRLOFBXX/mrcOAo9KGA
         vBULOTj0fp+TBAWszpkottQmlwVUI2wd0BcjkdIavJSkcxxxrmvwbibs58iLiaJsgx
         69t+jL5zDHzlQ==
Date:   Wed, 31 Aug 2022 21:47:42 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH v2 0/6] x86/sgx: A collection of tests and fixes
Message-ID: <Yw+szo86olDDZq8s@kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <cfa17cdd-796e-be75-d371-9dea9c2876e8@intel.com>
 <Yw+kZdGBYEQARYIm@kernel.org>
 <37c35ede-b453-0d62-cee6-802ef98ae1ff@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37c35ede-b453-0d62-cee6-802ef98ae1ff@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 31, 2022 at 11:24:52AM -0700, Dave Hansen wrote:
> On 8/31/22 11:11, Jarkko Sakkinen wrote:
> > On Wed, Aug 31, 2022 at 10:43:05AM -0700, Dave Hansen wrote:
> >> Jarkko,
> >>
> >> What is your expectations of this series?  There's nothing in the cover
> >> letter.
> >>
> >> Do you think all of this is urgent material that needs to go to Linus
> >> for 6.0?  Or is it all 6.1 material?
> > Hmm... Let me think.
> > 
> > I would pick exactly 2/6 and 3/6 and postpone rest for 6.1.
> > 
> > 2/6 is IMHO critical fix and 3/6 is fix for a commit that
> > is part of 6.0.
> 
> That's really great context, thanks!  Next time, could you please
> include that in your cover letter(s) and split the patches up between
> urgent non-urgent bits?

I can, no problem.

BR, Jarkko
