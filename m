Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADA4C25B08
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Aug 2022 19:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345908AbiHITMh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345678AbiHITJ1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 9 Aug 2022 15:09:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A2A27178
        for <linux-sgx@vger.kernel.org>; Tue,  9 Aug 2022 11:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12B08B81662
        for <linux-sgx@vger.kernel.org>; Tue,  9 Aug 2022 18:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6744CC433C1;
        Tue,  9 Aug 2022 18:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660071425;
        bh=/8pIuVtf4Dp47znzaJJVjI9m5ofuHKrW1nyqHJiuEKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=REX2W/Nwv3SknOLx73OCPmUAHUTbWLnMjjbbVsD7NpWcZzedGwOtcCEvSDthgSI7t
         5eAW2V48TRxZTDomHeJmjFGWcX66iQ1+xB8GWnE6IPsHd4SBfShFGSta4Vu41m3LOd
         UCyvrVEpsHaBk/mcW2PadWKw0eSAiBBAEByfAMIso+omnt2tXlQMB5gZIdJFMSEXrq
         T7wkCfBTgLeS8CLhOa/wIB+YpbLIM6so/YKhOpqSGDaVh2CZGSa4hLTJCumeakdxwa
         lPFPWtsRkhzDPRE+DGoJzK50Dp2jPs/xIdeYukNaI27jTAOuXJ5lkW9H8LfdIj74Pd
         O/IlxjMd1oldg==
Date:   Tue, 9 Aug 2022 21:57:01 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Message-ID: <YvKt/V/fKn1W6XB3@kernel.org>
References: <20220804201456.33418-1-vijay.dhanraj@intel.com>
 <YvD/DUGRBR2Tns88@kernel.org>
 <DM8PR11MB559100639C945285BF1D6F87F6639@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvEryXfefz62ivEa@kernel.org>
 <YvI6z7wgV2VQtNV7@kernel.org>
 <YvKGxIEpdnawb0bY@kernel.org>
 <DM8PR11MB5591108F54901FBB198E6E04F6629@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvKskgNrTDC/e8pf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvKskgNrTDC/e8pf@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 09, 2022 at 09:53:11PM +0300, Jarkko Sakkinen wrote:
> On Tue, Aug 09, 2022 at 05:08:21PM +0000, Dhanraj, Vijay wrote:
> > 
> > 
> > > -----Original Message-----
> > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > Sent: Tuesday, August 9, 2022 9:10 AM
> > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang, Haitao
> > > <haitao.huang@intel.com>
> > > Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
> > > 
> > > On Tue, Aug 09, 2022 at 01:45:35PM +0300, Jarkko Sakkinen wrote:
> > > > On Mon, Aug 08, 2022 at 06:29:13PM +0300, Jarkko Sakkinen wrote:
> > > > > On Mon, Aug 08, 2022 at 01:00:54PM +0000, Dhanraj, Vijay wrote:
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > > > > Sent: Monday, August 8, 2022 5:18 AM
> > > > > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > > > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > > > > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang,
> > > > > > > Haitao <haitao.huang@intel.com>
> > > > > > > Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
> > > > > > >
> > > > > > > On Thu, Aug 04, 2022 at 01:14:56PM -0700, vijay.dhanraj@intel.com
> > > wrote:
> > > > > > > > From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > > > > >
> > > > > > > > This commit adds a new test case which is same as
> > > > > > > > `augment_via_eaccept` but adds more number of EPC pages to
> > > > > > > > stress test
> > > > > > > `EAUG` via `EACCEPT`.
> > > > > > > >
> > > > > > > > Signed-off-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > > > > > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> > > > > > >
> > > > > > > Hey, to reproduce the original issue: does it reproduce on VM or
> > > > > > > should I run baremetal kernel?
> > > > > > >
> > > > > > > BR, Jarkko
> > > > > >
> > > > > > Hi Jarkko, The issue should be reproducible on baremetal kernel.
> > > > >
> > > > > Thanks.
> > > >
> > > > I need comment out other tests in order to make sane out of this :-)
> > > >
> > > > Mentioning this because came into realization that stress tests should
> > > > be IMHO moved each to a separate binary (so that they can be run
> > > > separately). Just a note (TODO) to myself.
> > > >
> > > > I'll work on this today again and *possibly* split your test to its
> > > > own application to get a starting point for forementioned.
> > > 
> > > I got
> > > 
> > > #  RUN           enclave.augment_via_eaccept_long ...
> > > # main.c:1241:augment_via_eaccept_long:test enclave: total_size = 8192,
> > > seg->size = 8192 # main.c:1241:augment_via_eaccept_long:test enclave:
> > > total_size = 12288, seg->size = 4096 #
> > > main.c:1241:augment_via_eaccept_long:test enclave: total_size = 36864,
> > > seg->size = 24576 # main.c:1241:augment_via_eaccept_long:test enclave:
> > > total_size = 40960, seg->size = 4096 #
> > > main.c:1259:augment_via_eaccept_long:mmaping pages at end of enclave...
> > > # main.c:1273:augment_via_eaccept_long:Entering enclave to run EACCEPT
> > > for each page of 8589934592 bytes may take a while ...
> > > #            OK  enclave.augment_via_eaccept_long
> > > 
> > > The CPU used for testing was according to /proc/cpuinfo:
> > > 
> > > model name      : Intel(R) Xeon(R) Gold 6338 CPU @ 2.00GHz
> > > 
> > > I have couple of queries:
> > > 
> > > 1. Is it possible to get dmesg output?
> > I did check the dmesg output but couldn't find anything related to the failure. Just the general log messages.
> > 
> > > 2. Do I have to repeat the test multiple times, or does it
> > >    occur unconditionaly?
> > > 
> > I was able to repro every time but it was a bit sporadic for Haitao.
> > 
> > > BR, Jarkko
> > 
> > Also, did you set the PRMRR size to 2GB per socket in the BIOS? The issue
> > is only reproduced for oversubscribed scenario. When I set my PRMRR to
> > 64GB per socket, I wasn't able to repro the issue.
> 
> I need to revisit this.
> 
> Can you simply run test_sgx with gdb and see where it hits?
> HOST_CFLAGS has apparently "-g" already.

I'll check the socket configuration but since you can steadily
reproduce the possible bug, this would be useful information
to dig out.

BR, Jarkko
