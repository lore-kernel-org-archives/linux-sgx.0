Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5EDC19F29
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Aug 2022 00:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbiHDA5U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Aug 2022 20:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiHDA5U (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 3 Aug 2022 20:57:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6935F12C
        for <linux-sgx@vger.kernel.org>; Wed,  3 Aug 2022 17:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D98306174C
        for <linux-sgx@vger.kernel.org>; Thu,  4 Aug 2022 00:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BA3C433D6;
        Thu,  4 Aug 2022 00:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659574638;
        bh=O0DiYX138qXsidBUsps6GuT1s2XiwvSVnKjNFHahrhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UffwnhnYY5lIzzLFMMhJSrNz+sNyZu0HD0NaxncMbEnlt8mj0caHEfvoYnkZEKh5H
         i+J/kaYpiiAd0xxX8vlsbjf6BV6BsBLIGFu+JmMHFws/NBihBx2EIjuUJEsQ+aXlGw
         r5IpfP1KGQt2jSfgEK/X7hleaYT2HzCRF0aaFYvLhUOHuIxpNO0hpvueynZJcz4KJs
         s6ozcu3S0d8cs1E58R4+Gu/cSSNjxJiKVPbIAqyu5sE4lsXG5nIvxbS86XfbZ+bDck
         Ou3ceNpzl/KrJNLFT9eORqGeZkRt8/BjrQnSS9lODbxQmWZuTleZz2ib7m5RLZLu2+
         EixvbzcNfi+PQ==
Date:   Thu, 4 Aug 2022 03:57:14 +0300
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
Cc:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC
 pages
Message-ID: <YusZaqa4p7KPeqYG@kernel.org>
References: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YuqwSw3enyOUTdON@kernel.org>
 <DM8PR11MB5591174FF99D6D2092E959A9F69F9@DM8PR11MB5591.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB5591174FF99D6D2092E959A9F69F9@DM8PR11MB5591.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 04, 2022 at 12:38:12AM +0000, Dhanraj, Vijay wrote:
> > 
> > Could you make this a proper patch for kselftest?
> > 
> > It looks fine. Only thing you need to do is to add instead a new test add a
> > new test called augment_via_eaccept_long. Please, also define this before

Oops, typos. I meant to say that you could add a new case, instead
of replacing the existing...

> Sure, will work on a patch and submit it.

Thank you! Looking forward to it.

BR, Jarkko
