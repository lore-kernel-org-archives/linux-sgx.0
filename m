Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA51FC19F2D
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Aug 2022 10:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiHIKpw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Aug 2022 06:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241127AbiHIKpn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 9 Aug 2022 06:45:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389E51F2F5
        for <linux-sgx@vger.kernel.org>; Tue,  9 Aug 2022 03:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4FF1B8111F
        for <linux-sgx@vger.kernel.org>; Tue,  9 Aug 2022 10:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56310C433C1;
        Tue,  9 Aug 2022 10:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660041939;
        bh=g1vKZQEXtF46WKnss3xODi73UNoCwcb1AXjfNljGGKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l+rpw4tXeELxMm8nwfCRJO7Ya892e0pH5kxRpIu9Z2a9LJzU5FyjfMNV9lE2F4p9h
         tBbk80L7Tm9O/nHYhl5TTIQGPU9qschvvEmDMBZFPiCDbPhPSN1FFofrAaQx+zrNPc
         duFYfqscf3u7qQ3J9Qlb/jdtcFPLkPe7+beswpNUy3v9/Zkob2T4o0ZQhFc9l2zNeC
         sCsKRCEpMgKeE7OBnSSWmYBkAFlg81kwDGv9joAAdH9Wh0v7C7OTDZe4HmrouNuq19
         EVI8Xphn+I5pbY56Qyb8mtbPwoDK1okyswgrq9BTxcx2kicc1bS/G7lbirRlQf3fFn
         55XCasI1/ZG1g==
Date:   Tue, 9 Aug 2022 13:45:35 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Message-ID: <YvI6z7wgV2VQtNV7@kernel.org>
References: <20220804201456.33418-1-vijay.dhanraj@intel.com>
 <YvD/DUGRBR2Tns88@kernel.org>
 <DM8PR11MB559100639C945285BF1D6F87F6639@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvEryXfefz62ivEa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvEryXfefz62ivEa@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 08, 2022 at 06:29:13PM +0300, Jarkko Sakkinen wrote:
> On Mon, Aug 08, 2022 at 01:00:54PM +0000, Dhanraj, Vijay wrote:
> > 
> > > -----Original Message-----
> > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > Sent: Monday, August 8, 2022 5:18 AM
> > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang, Haitao
> > > <haitao.huang@intel.com>
> > > Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
> > > 
> > > On Thu, Aug 04, 2022 at 01:14:56PM -0700, vijay.dhanraj@intel.com wrote:
> > > > From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > >
> > > > This commit adds a new test case which is same as
> > > > `augment_via_eaccept` but adds more number of EPC pages to stress test
> > > `EAUG` via `EACCEPT`.
> > > >
> > > > Signed-off-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> > > 
> > > Hey, to reproduce the original issue: does it reproduce on VM or should I run
> > > baremetal kernel?
> > > 
> > > BR, Jarkko
> > 
> > Hi Jarkko, The issue should be reproducible on baremetal kernel.
> 
> Thanks.

I need comment out other tests in order to make sane out of this :-)

Mentioning this because came into realization that stress tests should
be IMHO moved each to a separate binary (so that they can be run
separately). Just a note (TODO) to myself.

I'll work on this today again and *possibly* split your test to its own
application to get a starting point for forementioned.

BR, Jarkko


