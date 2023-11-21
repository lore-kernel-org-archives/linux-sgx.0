Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D64B4C71
	for <linux-sgx@vger.kernel.org>; Tue, 21 Nov 2023 01:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAS7CCs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47218C433C7;
	Tue, 21 Nov 2023 01:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700528919;
	bh=WydedWHI5hgSzmjYaAgFcEvQrWisnvd0Tah1sl3VwoE=;
	h=Date:From:To:Subject:From;
	b=xAS7CCs6peJWQDgbU1bYbCUrXfXDq3w1l+x15KDO3rid/+vTOU5H/+cfijr4D1EfD
	 mpBpVJc7RGFMSRTRDAuhoWx6BsGD7cxvuqvjA6a6HdeBQ9Hu6OdHekHHCa+J/+GOfm
	 0aFmXPSen5G+XG6CgbjItQxaCx4SkDbrkRr57I2w=
Date: Mon, 20 Nov 2023 20:08:38 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: linux-sgx@vger.kernel.org
Subject: PSA: this list has moved to new vger infra (no action required)
Message-ID: <20231120-ultramarine-hare-from-saturn-e6d9ec@nitro>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello, all:

This list has been migrated to new vger infrastructure. No action is required
on your part and there should be no change in how you interact with this list.

This message acts as a verification test that the archives are properly
updating.

If something isn't working or looking right, please reach out to
helpdesk@kernel.org.

Best regards,
-K
