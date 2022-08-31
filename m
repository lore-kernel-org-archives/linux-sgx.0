Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76BAECAAD1
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Aug 2022 18:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiHaSOB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Aug 2022 14:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiHaSNp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 31 Aug 2022 14:13:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD9DF14C7
        for <linux-sgx@vger.kernel.org>; Wed, 31 Aug 2022 11:12:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8C89B82271
        for <linux-sgx@vger.kernel.org>; Wed, 31 Aug 2022 18:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6FDC433C1;
        Wed, 31 Aug 2022 18:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661969513;
        bh=gJU39q3n1vPfq6jmKavWwupeF7Wx2by4s9jOR9JVHQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tiBdB7V0m84IUC4CWwkhKNf05FnmMjiLDF1NxtDNLetL7ckdETRoPVWq+L0xRSFXJ
         F5br1mwWvgj1UFOaa5xN9aU63XhAIFgJBFk9c7YCG5KxTF0Js7WAhyCbJ/DlrRuv2P
         9nMI60vsOgXuYb+Q/Wr/v2ExGzytiTYbMFC5qy++9EQMog7yd6RkoX5QqQvWABCnj/
         sFfVkM0HSsCLlT/SYiCnGyqG/CgWEqaRvoT+qZl2jqqHVVesQVMmu7U6n/2VRxVzO3
         WV5mEG3TUCWTu6xg9FVzGsZdi61fVdztEbT/0Tx+m04WFiJ1fqtWzrrYjjK14oeFlq
         qycYZf0WrHriw==
Date:   Wed, 31 Aug 2022 21:11:49 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH v2 0/6] x86/sgx: A collection of tests and fixes
Message-ID: <Yw+kZdGBYEQARYIm@kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <cfa17cdd-796e-be75-d371-9dea9c2876e8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfa17cdd-796e-be75-d371-9dea9c2876e8@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 31, 2022 at 10:43:05AM -0700, Dave Hansen wrote:
> Jarkko,
> 
> What is your expectations of this series?  There's nothing in the cover
> letter.
> 
> Do you think all of this is urgent material that needs to go to Linus
> for 6.0?  Or is it all 6.1 material?

Hmm... Let me think.

I would pick exactly 2/6 and 3/6 and postpone rest for 6.1.

2/6 is IMHO critical fix and 3/6 is fix for a commit that
is part of 6.0.

BR, Jarkko
