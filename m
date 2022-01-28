Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D85C433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jan 2022 10:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244220AbiA1KId (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jan 2022 05:08:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51704 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243932AbiA1KIc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 28 Jan 2022 05:08:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C02F61E27
        for <linux-sgx@vger.kernel.org>; Fri, 28 Jan 2022 10:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AF3C340E0
        for <linux-sgx@vger.kernel.org>; Fri, 28 Jan 2022 10:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643364511;
        bh=PcHnbOH9XDvCa5SRl5iZRmFpEWdvK2N2DgSjvPEeoZA=;
        h=Date:From:To:Subject:From;
        b=URZ3q6wZessWj5u8IZFAXsmOfOZ5hYO3mXut+9ZEWbamBLP69iDTlw7KR6hf4rX6K
         PkITJnn6ko58y5XTtWgnlENm/X5kPGT8ltMjynFdQYUr8H7cANqg6sgn1kX1NGEq3O
         CcpCCyu4wvpzKJGI5zKRNCQGqcZiRjRVSHXL6NA3LhG4n+Vws97OaJJCSfkodCaMpw
         I5N8xjz/QAdEH6A+fkOoMJ0Edx47Dh3WO1NYzJcLFPeSGyB8P8JerI9QCKNyAVPI2d
         iz/pe+jf/jvf1x+6lBSNsLZB6cSPyjBKN4eK5topF9za4i5XXzpqxWDDF9UjRLfTC8
         dNBAB/M7xo4pg==
Date:   Fri, 28 Jan 2022 12:08:07 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Subject: aesmd availability
Message-ID: <YfPAh8m1c9LI6plB@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

I noticed that with aesmd the only feasible way to host it is to make a
VM for it because:

- A beter predictable round-trip time for attestation.
- In the worst case, attestation could be potentially blocked.

Should the driver have a page locking mechanism to make this more robust,
or do we want to satisfy to this? I'm not 100% sure what'd be the right
path forward, just pointing out a potential availability issue.

BR, Jarkko
