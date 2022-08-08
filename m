Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457B8C00140
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Aug 2022 15:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243690AbiHHP3U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Aug 2022 11:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243628AbiHHP3T (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 8 Aug 2022 11:29:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BF41408C
        for <linux-sgx@vger.kernel.org>; Mon,  8 Aug 2022 08:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06C6A60FF8
        for <linux-sgx@vger.kernel.org>; Mon,  8 Aug 2022 15:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D354C433D6;
        Mon,  8 Aug 2022 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659972557;
        bh=RoZQcHafEtHaUmqWfvMN6DMnRpxC4uNhAVbe8p1YS9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WuxD/0cCef1dGETwDMEsPkJyIIc8MZLWhIn8KaSwmuqsPyxrc/SaTOnvxvU/jBAGw
         yRjrf8GWoQObK0Ym61DdE4TGgsOHgogU7L7v5bYIRy9tmb95Li8JURO5ZjyGrN+ORF
         stHnNxrrxLU+tOz9MMOvvmS3AyLpyhzju28fiZZXPPqBQQRZR/RsNj+Z1otSGbvszr
         fJn98rsdB7V6ientu2A3uqbj/HA07tMt6qlQm0xlNQ+oxHuJgxbkC7kRg9WDfw3Ppp
         vIv5J0ccKRrH7/qg1PaOxIKtjk3Dv8Hkv6J9fBSNFmPSHsUozlWrr+cDiOVPeQlsJm
         YakKV+BZCuiAg==
Date:   Mon, 8 Aug 2022 18:29:13 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Message-ID: <YvEryXfefz62ivEa@kernel.org>
References: <20220804201456.33418-1-vijay.dhanraj@intel.com>
 <YvD/DUGRBR2Tns88@kernel.org>
 <DM8PR11MB559100639C945285BF1D6F87F6639@DM8PR11MB5591.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB559100639C945285BF1D6F87F6639@DM8PR11MB5591.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 08, 2022 at 01:00:54PM +0000, Dhanraj, Vijay wrote:
> 
> > -----Original Message-----
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > Sent: Monday, August 8, 2022 5:18 AM
> > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang, Haitao
> > <haitao.huang@intel.com>
> > Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
> > 
> > On Thu, Aug 04, 2022 at 01:14:56PM -0700, vijay.dhanraj@intel.com wrote:
> > > From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > >
> > > This commit adds a new test case which is same as
> > > `augment_via_eaccept` but adds more number of EPC pages to stress test
> > `EAUG` via `EACCEPT`.
> > >
> > > Signed-off-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> > 
> > Hey, to reproduce the original issue: does it reproduce on VM or should I run
> > baremetal kernel?
> > 
> > BR, Jarkko
> 
> Hi Jarkko, The issue should be reproducible on baremetal kernel.

Thanks.

BR, Jarkko
