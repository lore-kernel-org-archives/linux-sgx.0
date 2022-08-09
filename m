Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2D5C19F2D
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Aug 2022 16:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244598AbiHIQJq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbiHIQJp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 9 Aug 2022 12:09:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2354F1132
        for <linux-sgx@vger.kernel.org>; Tue,  9 Aug 2022 09:09:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAE07612F2
        for <linux-sgx@vger.kernel.org>; Tue,  9 Aug 2022 16:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7F8C433C1;
        Tue,  9 Aug 2022 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660061384;
        bh=MWSAh9b2u9IpzMhWxIprq9VBkQp2ab2ujV2Whrjh5EE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ckyMGJ9WXkPlGag762dVCVlWrvXagtT8EiYKheqyBpf8UK1/NvUhHyXgPQgd/ftEs
         dWv9ROSgrU2QNZ0b7/MTcKuU6EdO3v4miBcuWUfYSigOP2U/2sDY8m06jJYJJ92aaQ
         qonaVNTrMjayc2J+FwYztb6YCgUvZNtkApZXDa78pDn64JvLnCpYCaFpWBW+zNz50M
         HtenV8Duo/urrQlADgnn3zo7cAEUF8sf2AhaXRy0bLBFDnC9VcPV9FrFfIHKNGgDiz
         OQHQ/Q+1XQhYv+rLXQxWGgoXXkymtVixMfRgAwmstweOk5lX9o2DUnznW5eA+Y0Cnw
         0hcNCG/b9a8ZQ==
Date:   Tue, 9 Aug 2022 19:09:40 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Message-ID: <YvKGxIEpdnawb0bY@kernel.org>
References: <20220804201456.33418-1-vijay.dhanraj@intel.com>
 <YvD/DUGRBR2Tns88@kernel.org>
 <DM8PR11MB559100639C945285BF1D6F87F6639@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvEryXfefz62ivEa@kernel.org>
 <YvI6z7wgV2VQtNV7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvI6z7wgV2VQtNV7@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 09, 2022 at 01:45:35PM +0300, Jarkko Sakkinen wrote:
> On Mon, Aug 08, 2022 at 06:29:13PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Aug 08, 2022 at 01:00:54PM +0000, Dhanraj, Vijay wrote:
> > > 
> > > > -----Original Message-----
> > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > Sent: Monday, August 8, 2022 5:18 AM
> > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang, Haitao
> > > > <haitao.huang@intel.com>
> > > > Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
> > > > 
> > > > On Thu, Aug 04, 2022 at 01:14:56PM -0700, vijay.dhanraj@intel.com wrote:
> > > > > From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > >
> > > > > This commit adds a new test case which is same as
> > > > > `augment_via_eaccept` but adds more number of EPC pages to stress test
> > > > `EAUG` via `EACCEPT`.
> > > > >
> > > > > Signed-off-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> > > > 
> > > > Hey, to reproduce the original issue: does it reproduce on VM or should I run
> > > > baremetal kernel?
> > > > 
> > > > BR, Jarkko
> > > 
> > > Hi Jarkko, The issue should be reproducible on baremetal kernel.
> > 
> > Thanks.
> 
> I need comment out other tests in order to make sane out of this :-)
> 
> Mentioning this because came into realization that stress tests should
> be IMHO moved each to a separate binary (so that they can be run
> separately). Just a note (TODO) to myself.
> 
> I'll work on this today again and *possibly* split your test to its own
> application to get a starting point for forementioned.

I got

#  RUN           enclave.augment_via_eaccept_long ...
# main.c:1241:augment_via_eaccept_long:test enclave: total_size = 8192, seg->size = 8192
# main.c:1241:augment_via_eaccept_long:test enclave: total_size = 12288, seg->size = 4096
# main.c:1241:augment_via_eaccept_long:test enclave: total_size = 36864, seg->size = 24576
# main.c:1241:augment_via_eaccept_long:test enclave: total_size = 40960, seg->size = 4096
# main.c:1259:augment_via_eaccept_long:mmaping pages at end of enclave...
# main.c:1273:augment_via_eaccept_long:Entering enclave to run EACCEPT for each page of 8589934592 bytes may take a while ...
#            OK  enclave.augment_via_eaccept_long

The CPU used for testing was according to /proc/cpuinfo:

model name      : Intel(R) Xeon(R) Gold 6338 CPU @ 2.00GHz

I have couple of queries:

1. Is it possible to get dmesg output?
2. Do I have to repeat the test multiple times, or does it
   occur unconditionaly?

BR, Jarkko
