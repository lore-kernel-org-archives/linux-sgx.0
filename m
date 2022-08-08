Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF56C00140
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Aug 2022 12:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbiHHMS2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Aug 2022 08:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242339AbiHHMS1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 8 Aug 2022 08:18:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4406114D04
        for <linux-sgx@vger.kernel.org>; Mon,  8 Aug 2022 05:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 004E8B80E73
        for <linux-sgx@vger.kernel.org>; Mon,  8 Aug 2022 12:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691F3C433C1;
        Mon,  8 Aug 2022 12:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659961104;
        bh=sUzNQSP9q/DLIz+/kPx3q664QHnQlNbFUvYTL2td3SE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qimroezDJjTetzPHfsUZuIMQ5mWJKhEWL+DCgMhFjjg8o9rsjHPx8uGjgGOwMAKp1
         wN6wZ6sCVSdvoGKVhf9parK3hirS9fKrSVMxvfp6X2gmC3dR1NbymhTUO2RqrYiqZ+
         xXgf0l6xTmkFLpnSIIuaDjdIRycrc+IKJymw54qk42VHeONrcDQWRJV3t2fEqwiT1f
         9qbeW/nVdq411vgHvyeecAFnMBbLqHYWkhBmcHIWiWa6NoVYHbhNZxJSE15MuNRVIH
         /Lgz1qT0FoscrmQbWADoFJ1VzwgukdyLnYZOdQBJahPn4pjci6XfDo505dN+SRSR8o
         Y5Tz3RdMMfk9Q==
Date:   Mon, 8 Aug 2022 15:18:21 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     vijay.dhanraj@intel.com
Cc:     linux-sgx@vger.kernel.org, reinette.chatre@intel.com,
        dave.hansen@linux.intel.com, haitao.huang@intel.com
Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Message-ID: <YvD/DUGRBR2Tns88@kernel.org>
References: <20220804201456.33418-1-vijay.dhanraj@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804201456.33418-1-vijay.dhanraj@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 04, 2022 at 01:14:56PM -0700, vijay.dhanraj@intel.com wrote:
> From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> 
> This commit adds a new test case which is same as `augment_via_eaccept`
> but adds more number of EPC pages to stress test `EAUG` via `EACCEPT`.
> 
> Signed-off-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>

Hey, to reproduce the original issue: does it reproduce on VM or
should I run baremetal kernel?

BR, Jarkko
