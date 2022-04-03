Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71D7C433F5
	for <linux-sgx@archiver.kernel.org>; Sun,  3 Apr 2022 10:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiDCKV0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 3 Apr 2022 06:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiDCKVZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 3 Apr 2022 06:21:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9F727CF8
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 03:19:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 238FA60FFF
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 10:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD93C340ED;
        Sun,  3 Apr 2022 10:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648981170;
        bh=OjgIhy2GBf6B0Dk0uz6mSzuNtIoCgTBc3EihDGn7cu4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LAEMSsJIhWqwim9YNJlh1uDfKkzqL5jdRioHQ1KmP4F+P+TCnd+HLvIFsNtEN6Lft
         tyLKbkTvpSnk9lBazB3hEov4Yx20CX16IFO1XGdHEAhPed25qIB7YnYhrSTfwLn/jC
         4JlD+r7BFgDkF4Q9FFepstbRACP8as2wrffBgXyCBXD4uJUhOHVgNbP6sxUxBDuP8m
         29T1/7tu8bJsnc+6c7rgjctMWthC9/LXlbkvZjPWYAOMVwbq9BgrOA5C4GFxFzBBLK
         U+Dh3gn73LTIiWZ1m/Jo9o6vsyJDnqpxNMuAMyC1mnGGFiAn8ZExaduQKadrNoNN1x
         pVn5r6/yHog7g==
Date:   Sun, 3 Apr 2022 13:20:40 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        reinette.chatre@intel.com, dave.hansen@intel.com,
        ashok.raj@intel.com
Subject: Re: [RFC PATCH v3 06/10] x86/sgx: Forced EPC page zapping for
 EUPDATESVN
Message-ID: <Ykl0+Da6t7z9VSuA@kernel.org>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-7-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401142409.26215-7-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 01, 2022 at 10:24:05PM +0800, Cathy Zhang wrote:
> Before an EUPDATESVN instruction can be successful, all enclave
> pages (EPC) must be marked as unused in the SGX hardware
> metadata (EPCM).
> 
> A page becomes unused when an issued EREMOVE instruction succeeds.
> To prepare for EUPDATESVN, loop over all SGX pages and attempt
> to EREMOVE them. This is fatal to running enclaves and destroys
> all enclave state and memory contents. This destruction is by
> design and mitigates any compromise of enclaves or the SGX
> hardware itself which occurred before the microcode update.
> 
> An EREMOVE operation on a page may fail for a few reasons. Each
> has its own mitigations.
> 
> First, EREMOVE will fail if an enclave that uses the page is
> executing. Send an IPI to all CPUs that might be running the
> enclave to force it out of the enclave long enough to EREMOVE
> the page. Other CPUs might enter the enclave in the meantime,
> so this is not a rock-solid guarantee.
> 
> Second, EREMOVE can fail on special SGX metadata pages, such as
> SECS and VA. EREMOVE will work on them only after the normal SGX

Ignoring concurrency rules that apply to any type of EPC page, VA page can
be removed at any point of time, i.e. the first sentence in this paragraph
is not factually true.

BR, Jarkko
